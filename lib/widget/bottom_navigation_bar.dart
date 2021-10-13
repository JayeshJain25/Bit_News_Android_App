import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto_news/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../screen/favourite_screen.dart';
import '../screen/market_screen.dart';
import '../screen/news_screen.dart';
import 'no_internet.dart';

class AppBottomNavigationBar extends StatefulWidget {
  @override
  _MyCustomBottomNavigationBarState createState() =>
      _MyCustomBottomNavigationBarState();
}

class _MyCustomBottomNavigationBarState extends State<AppBottomNavigationBar>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool isDeviceConnected = false;

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
      const HomeScreen(),
      MarketScreen(),
      FavouriteScreen(),
      NewsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder(
          stream: Connectivity().onConnectivityChanged,
          builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {
            if (snapshot.data == ConnectivityResult.mobile ||
                snapshot.data == ConnectivityResult.wifi) {
              //  isDeviceConnected =  await DataConnectionChecker().hasConnection;
              return _buildScreens().elementAt(_currentIndex);
            } else {
              return const NoInternet();
            }
          },
        ),
      ),
      bottomNavigationBar: GNav(
        tabMargin:
            const EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 25),
        backgroundColor: const Color(0xFF010101),
        curve: Curves.easeOutExpo,
        duration: const Duration(milliseconds: 600),
        activeColor: const Color(0xFF52CAF5),
        color: Colors.white38,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),

        tabs: [
          GButton(
            backgroundColor: const Color(0xFF010101),
            leading: SizedBox(
              width: 24,
              height: 24,
              child: ImageIcon(
                const CachedNetworkImageProvider(
                    'https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/home.png?alt=media&token=6069b526-8886-4c2e-8dca-3bccd342c093'),
                color:
                    _currentIndex == 0 ? const Color(0xFF52CAF5) : Colors.white,
              ),
            ),
            icon: Icons.notifications_none,
            iconColor: Colors.transparent,
          ),
          GButton(
            backgroundColor: const Color(0xFF010101),
            leading: SizedBox(
              width: 24,
              height: 24,
              child: ImageIcon(
                const CachedNetworkImageProvider(
                    'https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/market.png?alt=media&token=91aad10c-9e4e-4e2c-bc4d-0f0ab6ce661c'),
                color:
                    _currentIndex == 1 ? const Color(0xFF52CAF5) : Colors.white,
              ),
            ),
            icon: Icons.notifications_none,
            iconColor: Colors.transparent,
          ),
          GButton(
            leading: SizedBox(
              width: 24,
              height: 24,
              child: ImageIcon(
                const CachedNetworkImageProvider(
                    'https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/star.png?alt=media&token=118b56b3-5fe2-47d7-9498-a6c6da9a1725'),
                color:
                    _currentIndex == 2 ? const Color(0xFF52CAF5) : Colors.white,
              ),
            ),
            icon: Icons.notifications_none,
            iconColor: Colors.transparent,
            backgroundColor: const Color(0xFF010101),
          ),
          GButton(
            leading: SizedBox(
              width: 24,
              height: 24,
              child: ImageIcon(
                const CachedNetworkImageProvider(
                    'https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/news.png?alt=media&token=0e1a6a88-64bc-43ac-b0b4-f0ffc2758a17'),
                color:
                    _currentIndex == 3 ? const Color(0xFF52CAF5) : Colors.white,
              ),
            ),
            icon: Icons.notifications_none,
            iconColor: Colors.transparent,
            backgroundColor: const Color(0xFF010101),
          ),
        ],
        selectedIndex: _currentIndex,
        //New
        onTabChange: _onItemTapped,
      ),
    );
  }
}
