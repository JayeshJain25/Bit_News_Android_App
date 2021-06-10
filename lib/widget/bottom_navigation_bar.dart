import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../screen/favouriteScreen.dart';
import '../screen/marketScreen.dart';
import '../screen/newsScreen.dart';
import '../screen/notificationScreen.dart';

void main() => runApp(Nav());

class Nav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BottomNavigationBar(),
    );
  }
}

class BottomNavigationBar extends StatefulWidget {
  @override
  _MyCustomBottomNavigationBarState createState() =>
      _MyCustomBottomNavigationBarState();
}

class _MyCustomBottomNavigationBarState extends State<BottomNavigationBar> {
  int _currentIndex = 0;

  List<Widget> _buildScreens() {
    return [
      MarketScreen(),
      FavouriteScreen(),
      NewsScreen(),
      NotificationScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _buildScreens().elementAt(_currentIndex),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: HexColor("#4E8799"),
        color: Colors.black,
        height: 50,
        animationCurve: Curves.fastOutSlowIn,
        items: <Widget>[
          const ImageIcon(
            AssetImage('lib/assets/cryptocurrency.png'),
            size: 20,
            color: Colors.white,
          ),
          const Icon(
            Icons.star,
            size: 20,
            color: Colors.white,
          ),
          const ImageIcon(
            AssetImage('lib/assets/news.png'),
            size: 20,
            color: Colors.white,
          ),
          const Icon(
            Icons.notifications,
            size: 20,
            color: Colors.white,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
