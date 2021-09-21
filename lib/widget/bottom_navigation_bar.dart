import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
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
      bottomNavigationBar: GNav(
        tabMargin: const EdgeInsets.only(top: 10,bottom: 10,left: 5,right: 5),
        backgroundColor: const Color(0xFF121212),
        rippleColor: Colors.grey.shade800, // tab button ripple color when pressed
        hoverColor: Colors.grey.shade700, // tab button hover color
        tabBorderRadius: 20,
        tabActiveBorder: Border.all(color: Colors.white, width: 0.5),
        curve: Curves.easeOutExpo,
        duration: const Duration(milliseconds: 600),
        gap: 5,
        activeColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),

        tabs:const [
          GButton(
            backgroundColor: Color(0xFF121212),
            leading:  SizedBox(
            width: 24,
            height: 24,
            child: ImageIcon(AssetImage('lib/assets/market.png'),color: Colors.white),
          ),
            text: 'Market', icon:  Icons.notifications_none,iconColor: Colors.transparent,
          ),
          GButton(
            leading:  SizedBox(
              width: 24,
              height: 24,
              child:  ImageIcon(AssetImage('lib/assets/star.png'),color: Colors.white),
            ),
            icon:  Icons.notifications_none,iconColor: Colors.transparent,
            text: 'Favourite',
            backgroundColor: Color(0xFF121212),
          ),
          GButton(
            leading:  SizedBox(
              width: 24,
              height: 24,
              child: ImageIcon(AssetImage('lib/assets/news.png'),color: Colors.white),
            ),
            icon:  Icons.notifications_none,iconColor: Colors.transparent,
            text: 'News',
            backgroundColor: Color(0xFF121212),
          ),
          GButton(
            icon: Icons.notifications_none,
            text: 'Notification',
            iconColor: Colors.white,
            backgroundColor: Color(0xFF121212),
          ),
        ],
        selectedIndex: _currentIndex,
        //New
        onTabChange: _onItemTapped,
      ),
    );
  }
}
