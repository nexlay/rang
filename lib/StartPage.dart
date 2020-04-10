import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';
import 'package:sqflite/sqflite.dart';
import 'database/Number.dart';
import 'database/database_helper.dart';
import 'dart:async';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: homePage,
    );
  }
}

Widget homePage = Container(
  child: HomePage(),
);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DataBaseHelper dataBaseHelper =
      DataBaseHelper(); // Database helper for using all the functionality of our database
  Number number; // Object with a title which is number
  int _counter = 0; // generated numbers value
  bool _exist = false; // check if object already exist in DB
  int _id = 0; // variable for storing returned id
  List<Number> _saved; // set of random numbers
  String baseUrl = 'http://numbersapi.com/';
  var description;

  final _minRetrieveController = TextEditingController();
  final _maxRetrieveController = TextEditingController();
  final double _fontSize = 75.0;

  @override
  void initState() {
    if (_saved == null) {
      _saved = List<Number>();
    }
    _updateList();
    super.initState();
  }

  @override
  void dispose() {
    _minRetrieveController.dispose();
    _maxRetrieveController.dispose();
    super.dispose();
  }

  void _randomCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.

      String minValue = _minRetrieveController.text;
      String maxValue = _maxRetrieveController.text;

      Random random = Random();
      _counter = random.nextInt(int.parse(maxValue) + 1 - int.parse(minValue)) +
          int.parse(minValue);

      _updateList();
      _createObject();
      _checkIfExist(number);
    });
  }

  _checkIfExist(Number object) {
    for (int i = 0; i < _saved.length; i++) {
      if (object.title == _saved[i].title) {
        _id = _saved[i].id;
        return _exist = true;
      }
    }
    return _exist = false;
  }

  _createObject() {
    number = Number();
    number.title = _counter;
  }

  _saveToFavorite() {
    //This method is save or delete data to/from database after "Favorite" button clicked
    setState(() {
      if (_exist) {
        _exist = false;
        number.id = _id;
        _deleteItemFromDb(context, number);
        _updateList();
      } else {
        _exist = true;
        _saveDataToDb(number);
        _updateList();
      }
    });
  }

  _updateList() {
    //Here we get a list from our database
    final Future<Database> db = dataBaseHelper.initDatabase();
    db.then((database) {
      Future<List<Number>> listFuture = dataBaseHelper.getNumberList();
      listFuture.then((_saved) {
        setState(() {
          this._saved = _saved;
        });
      });
    });
  }

  void _saveDataToDb(Number numberObj) async {
    await dataBaseHelper.insertData(numberObj);
  }

  void _deleteItemFromDb(BuildContext context, Number numberObj) async {
    await dataBaseHelper.deleteData(numberObj.id);
  }


  void _showAlertDialog(String title, String description) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(description),
      elevation: 24,
      actions: <Widget>[
        FlatButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // to see the wireframe for each widget.
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Result',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Text(
                    '$_counter',
                    style: TextStyle(fontSize: _fontSize, color: Colors.red),
                  ),
                  IconButton(
                    icon: _exist
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border),
                    onPressed: _saveToFavorite,
                    color: _exist ? Colors.red : null,
                    iconSize: 35,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _minRetrieveController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Min number',
                        ),
                        keyboardType: TextInputType.numberWithOptions(),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _maxRetrieveController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Max number',
                        ),
                        keyboardType: TextInputType.numberWithOptions(),
                      ),
                    ),
                  ],
                ),
              ),
              ButtonBar(
                mainAxisSize: MainAxisSize.max,
                alignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ButtonTheme(
                    minWidth: 150.0,
                    height: 55.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red)),
                    child: RaisedButton(
                      elevation: 1.5,
                      onPressed: () {
                        if (_minRetrieveController.text.isEmpty ||
                            _maxRetrieveController.text.isEmpty) {
                          _showAlertDialog('Epmty fields',
                              'Please, enter min and max values!');
                        } else
                          _randomCounter();
                      },
                      child: Text('Generate', style: TextStyle(fontSize: 16.0)),
                      textColor: Colors.white,
                      color: Colors.red,
                      splashColor: Colors.white,
                    ),
                  ),
                  ButtonTheme(
                    minWidth: 100.0,
                    height: 55.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.white)),
                    child: RaisedButton(
                      elevation: 1.5,
                      onPressed: () {
                        _minRetrieveController.clear();
                        _maxRetrieveController.clear();
                        setState(() {
                          _counter = 0;
                          _exist = false;
                        });
                      },
                      child: Text(
                        'Clear',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      textColor: Colors.red,
                      color: Colors.white,
                      splashColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
