import 'package:flutter/material.dart';

import '../screen/favourite_screen.dart';
import '../screen/market_screen.dart';
import '../screen/news_screen.dart';
import '../screen/notification_screen.dart';


class AppBottomNavigationBar extends StatefulWidget {
  @override
  _MyCustomBottomNavigationBarState createState() =>
      _MyCustomBottomNavigationBarState();
}

class _MyCustomBottomNavigationBarState extends State<AppBottomNavigationBar>
    with TickerProviderStateMixin {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF121212),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedIconTheme: const IconThemeData(color: Colors.amberAccent),
        selectedItemColor: Colors.amberAccent,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Color(0xFF121212),
            icon: ImageIcon(
              AssetImage('lib/assets/market.png'),
            ),
            label: 'Calls',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('lib/assets/star.png')),
            label: 'Calls',
            backgroundColor: Color(0xFF121212),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('lib/assets/news.png')),
            label: 'Calls',
            backgroundColor: Color(0xFF121212),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: 'Calls',
            backgroundColor: Color(0xFF121212),
          ),
        ],
        currentIndex: _currentIndex,
        //New
        onTap: _onItemTapped,
      ),
    );
  }
}
