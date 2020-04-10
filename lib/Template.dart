import 'package:flutter/material.dart';
import 'AboutPage.dart';
import 'Favorite.dart';
import 'StartPage.dart';

class SimpleBttmNavBar extends StatefulWidget {
  @override
  _NavBarItemState createState() => _NavBarItemState();
}

class _NavBarItemState extends State<SimpleBttmNavBar> {
  int _selectedItem = 1;
  final List<Widget> _pageList = [AboutPage(), StartPage()];
  final List<String> _titleList = ['About', 'Home'];
  //ScrollController _scrollController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageDetector(context),
      bottomNavigationBar: _bottomNavigationBar,
    );
  }
  /*@override
  void initState(){
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }
  _scrollListener(){
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _expanded = false;
      });
    }
    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _expanded = true;
      });
    }
  }
*/
  Widget _pageDetector (BuildContext context){
    if(_selectedItem == 2){
      return Favorite();
    }else return _buildScroll(context);
  }

  Widget _buildScroll(BuildContext context) => CustomScrollView(
    slivers: <Widget>[
      SliverAppBar(
        expandedHeight: 120,
        pinned: true,
        floating: false,
        backgroundColor: Colors.white,
        flexibleSpace: FlexibleSpaceBar(
          title: Text(_titleList[_selectedItem],
            style: TextStyle(
              color: Colors.black,
              fontSize: 37,
            ),
          ),
          titlePadding: EdgeInsets.only(left: 20, bottom: 4),
        ),
      ),
      SliverFillRemaining(
        child: _pageList[_selectedItem],
      ),
    ],
  );



  Widget get _bottomNavigationBar => ClipRRect(
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(8), topRight: Radius.circular(8)),
    child: BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          title: Text('About'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          title: Text('Like'),
        ),
      ],
      backgroundColor: Colors.white,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      unselectedItemColor: Colors.grey[500],
      selectedItemColor: Colors.red,
      currentIndex: _selectedItem,
      onTap: _itemOnTap,
    ),
  );

  void _itemOnTap(int value) {
    setState(() {
      _selectedItem = value;
    });
  }
}
