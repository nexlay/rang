import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'database/Number.dart';
import 'database/database_helper.dart';

class Favorite extends StatefulWidget {
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  // helper for calling all methods from database_helper.class
  DataBaseHelper dataBaseHelper = DataBaseHelper();

  // list of Number instances in database
  List<Number> list;

  // check if delete button is clicked
  bool _clicked = false;

  @override
  void initState() {
    if (list == null) {
      list = List<Number>();
    }
    _updateList();
    super.initState();
  }

  //Here we get list from our database
  _updateList() {
    final Future<Database> db = dataBaseHelper.initDatabase();
    db.then((database) {
      Future<List<Number>> listFuture = dataBaseHelper.getNumberList();
      listFuture.then((listOfNumbers) {
        setState(() {
          this.list = listOfNumbers;
        });
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildList(context),
      floatingActionButton: FloatingActionButton(
        child: _clicked ? Icon(Icons.delete) : Icon(Icons.delete_outline),
        backgroundColor: Colors.white,
        foregroundColor: _clicked ? Colors.red : Colors.grey,
        mini: true,
        elevation: 1.5,
        onPressed: () {
          _clicked = true;
          if (list.isEmpty) {
            _showAlertDialog(
                'Database is empty',
                "All this app's data was deleted earlier. This includes all history, databases, etc.",
                null);
          } else {
            _showAlertDialog(
                'Delete app data?',
                "All this app's data will be deleted. This includes all history, databases, etc.",
                null);
          }
        },
      ),
    );
  }

  Widget _buildList(BuildContext context) => CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            floating: false,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Favorite',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 37,
                ),
              ),
              titlePadding: EdgeInsets.only(left: 20, bottom: 4),
            ),
          ),
          list.isNotEmpty
              ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, index) {
                      return _buildTile(context, list[index]);
                    },
                    childCount: list.length,
                  ),
                )
              : SliverFillRemaining(
                  child: Icon(Icons.description,
                      color: Colors.grey[300], size: 65),
                ),
        ],
      );

  Widget _buildTile(context, Number number) {
    int title = number.title;
    return Column(
      children: <Widget>[
        ListTile(
          leading: _buildIcon(context, number),
          title: number.content != null
              ? Text(
                  number.content,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                )
              : Text('Loading...'),
          onTap: () {},
          onLongPress: () {
            _showAlertDialog(
                'Number $title', 'Do you want to delete this tile?', number);
          },
          selected: true,
        ),
        Divider(
          thickness: 1,
          height: 50,
          indent: 90,
          endIndent: 40,
        ),
      ],
    );
  }

  Widget _buildIcon(context, Number number) {
    int title = number.title;
    return SizedBox(
      width: 68,
      child: CircleAvatar(
        radius: 26,
        backgroundColor: Colors.red[50],
        child: Text(
          '$title',
          style: TextStyle(color: Colors.red, fontSize: 30),
        ),
      ),
    );
  }

  _deleteItemFromDb(BuildContext context, Number number) async {
    await dataBaseHelper.deleteData(number.id);
  }

  _deleteAllDb(BuildContext context) async {
    await dataBaseHelper.deleteAllData();
  }

  _alertDetector(String title, String description, Number number) {
    if (description == 'Do you want to delete this tile?') {
      _deleteItemFromDb(context, number);
    } else {
      _deleteAllDb(context);
    }
  }

  void _showAlertDialog(String title, String description, Number number) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(description),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      actions: <Widget>[
        FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(const Radius.circular(20.0))),
            child: list.isEmpty ? null : Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(const Radius.circular(20.0))),
            child: Text('OK'),
            onPressed: () {
              _alertDetector(title, description, number);
              _updateList();
              Navigator.of(context).pop();
            })
      ],
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
