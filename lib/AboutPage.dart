import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 100)),
          buildCircleAvatar(),
          titleSection,
          buttonSection,
          Expanded(
            child: description,
          ),
        ],
      ),
    );
  }
}

Widget titleSection = Container(
  padding: EdgeInsets.all(32.0),
  child: Row(
    children: <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                'Mykola Pryhodskyi',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              padding: EdgeInsets.only(bottom: 8.0),
            ),
            Text(
              'Bolesławiec, Poland',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      ),
      FavoriteWidget(),
    ],
  ),
);

Column _buildButtonBar(Color color, Icon icon, String label, int icNumb) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      IconButton(
        icon: icon,
        color: color,
        onPressed: () {
          String uri = '';
          if (icNumb == 1) {
            uri = 'tel:+48 733 037 046';
          } else if (icNumb == 2) {
            uri = 'https://goo.gl/maps/mVdUbmeCYEJqoCrTA';
          } else {
            Share.share('check out my twitter https://twitter.com/Nexlay',
                subject: 'Look what I made!');
          }
          _callMe(uri);
        },
      ),
      Container(
        margin: EdgeInsets.only(top: 8.0),
        child: Text(
          label,
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.w400),
        ),
      )
    ],
  );
}

final Color color = Colors.red;

Widget buttonSection = Container(
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      _buildButtonBar(
        color,
        Icon(Icons.call),
        'Call',
        1,
      ),
      _buildButtonBar(
        color,
        Icon(Icons.navigation),
        'Navigate',
        2,
      ),
      _buildButtonBar(
        color,
        Icon(Icons.share),
        'Share',
        3,
      ),
    ],
  ),
);
Widget description = Container(
  padding: EdgeInsets.only(left: 32.0, top: 32.0, right: 32.0),
  child: Text(
    'Hello, my name is Mykola Pryhodskyi. '
        "I'm 29 years old. "
        'I was born in Ukraine but now I live in Poland for about 5 years. '
        "I'm a beginner programmer. "
        'And I like to coding with Dart and Flutter. ',
    softWrap: true,
  ),
);
Widget buildCircleAvatar() =>
    Align(
      alignment: Alignment(-0.8, 0),
      child: CircleAvatar(
        backgroundImage: AssetImage('images/me.jpg'),
        radius: 60,
      ),

    );

_callMe(String uri) async {
  // Android
  if (await canLaunch(uri)) {
    await launch(uri);
  } else {
    throw 'Could not launch $uri';
  }
}

class FavoriteWidget extends StatefulWidget {
  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _isFavorite = false;
  int _favoriteCount = 0;

  @override
  void initState() {
    super.initState();
    _favoriteToggle();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          child: IconButton(
            icon: _isFavorite ? Icon(Icons.star) : Icon(Icons.star_border),
            color: Colors.red[500],
            onPressed: _favoriteToggleTrue,
          ),
        ),
        SizedBox(
          width: 18,
          child: Container(
            child: Text('$_favoriteCount'),
          ),
        ),
      ],
    );
  }

  _favoriteToggle() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    SharedPreferences count = await SharedPreferences.getInstance();
    setState(() {
      _isFavorite = (preferences.getBool('favorite') ?? false);
      _favoriteCount = (count.getInt('count') ?? 0);
    });
  }

  _favoriteToggleTrue() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    SharedPreferences count = await SharedPreferences.getInstance();
    _favoriteCount = (count.getInt('count') ?? 0);
    _isFavorite = (preferences.getBool('favorite') ?? false);

    if (_favoriteCount == 0) {
      _favoriteCount += 1;
      _isFavorite = true;
    } else {
      _favoriteCount -= 1;
      _isFavorite = false;
    }
    setState(() {
      preferences.setBool('favorite', _isFavorite);
      count.setInt('count', _favoriteCount);
    });
  }
}
