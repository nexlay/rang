import 'package:flutter/material.dart';
import 'dart:math';
import 'AboutPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random number generator practice',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      home: HomePage(title: 'Random number generator'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  final _minRetrieveController = TextEditingController();
  final _maxRetrieveController = TextEditingController();
  final double _fontSize = 75.0;

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
    });
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
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.info_outline), onPressed: _aboutApp),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 95.0),
              ),
              Text(
                'Result',
                style: TextStyle(fontSize: 20.0),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
              ),
              Text(
                '$_counter',
                style: TextStyle(fontSize: _fontSize, color: Colors.red),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _minRetrieveController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some number';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Min number',
                      ),
                      keyboardType: TextInputType.numberWithOptions(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _maxRetrieveController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some number';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Max number',
                      ),
                      keyboardType: TextInputType.numberWithOptions(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
              ),
              ButtonBar(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ButtonTheme(
                    minWidth: 150.0,
                    height: 55.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red)),
                    child: RaisedButton(
                      onPressed: () {
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
                      onPressed: () {
                        _minRetrieveController.clear();
                        _maxRetrieveController.clear();
                        setState(() {
                          _counter = 0;
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

  void _aboutApp() {
    var _route =
    MaterialPageRoute(builder: (BuildContext context) => AboutPage());
    Navigator.of(context).push(_route);
  }
}
