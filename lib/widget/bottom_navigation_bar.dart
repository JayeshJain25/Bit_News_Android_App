import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/screen/home_screen.dart';
import 'package:crypto_news/screen/setting_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screen/market_screen.dart';
import '../screen/news_screen.dart';

class AppBottomNavigationBar extends StatefulWidget {
  @override
  _MyCustomBottomNavigationBarState createState() =>
      _MyCustomBottomNavigationBarState();
}

class _MyCustomBottomNavigationBarState extends State<AppBottomNavigationBar>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool isDeviceConnected = false;
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFF010101),
        body: TabBarView(
          controller: _tabController,
          children: [
            HomeScreen(
              tabController: _tabController,
            ),
            MarketScreen(
              tabController: _tabController,
            ),
            NewsScreen(
              tabController: _tabController,
            ),
            SettingScreen(
              tabController: _tabController,
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: 60,
          decoration: const BoxDecoration(
            color: Color(0xFF0e0c0a),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: TabBar(
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: const EdgeInsets.all(5.0),
            indicatorColor: const Color(0xFF52CAF5),
            labelColor: const Color(0xFF52CAF5),
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(
                child: Stack(
                  children: [
                    const Positioned(
                      top: 10,
                      left: 20,
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: ImageIcon(
                          CachedNetworkImageProvider(
                            'https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/home.png?alt=media&token=6069b526-8886-4c2e-8dca-3bccd342c093',
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      child: Container(
                        width: 30,
                        height: 20,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: _currentIndex == 0
                                  ? const Color(0xFF52CAF5)
                                  : Colors.transparent,
                              blurRadius: 45.0, // soften the shadow
                              spreadRadius: 3.0, //extend the shadow
                              offset: const Offset(
                                17.0, 30.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ],
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Tab(
                child: Stack(
                  children: [
                    const Positioned(
                      top: 10,
                      left: 20,
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: ImageIcon(
                          CachedNetworkImageProvider(
                            'https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/market.png?alt=media&token=91aad10c-9e4e-4e2c-bc4d-0f0ab6ce661c',
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      child: Container(
                        width: 30,
                        height: 20,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: _currentIndex == 1
                                  ? const Color(0xFF52CAF5)
                                  : Colors.transparent,
                              blurRadius: 45.0, // soften the shadow
                              spreadRadius: 3.0, //extend the shadow
                              offset: const Offset(
                                17.0, 30.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ],
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Tab(
                child: Stack(
                  children: [
                    const Positioned(
                      top: 10,
                      left: 20,
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: ImageIcon(
                          CachedNetworkImageProvider(
                            'https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/news.png?alt=media&token=0e1a6a88-64bc-43ac-b0b4-f0ffc2758a17',
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      child: Container(
                        width: 30,
                        height: 20,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: _currentIndex == 2
                                  ? const Color(0xFF52CAF5)
                                  : Colors.transparent,
                              blurRadius: 45.0, // soften the shadow
                              spreadRadius: 3.0, //extend the shadow
                              offset: const Offset(
                                17.0, 30.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ],
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Tab(
                child: Stack(
                  children: [
                    const Positioned(
                      top: 10,
                      left: 20,
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: Icon(
                          Icons.settings,
                          size: 25,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      child: Container(
                        width: 30,
                        height: 20,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: _currentIndex == 3
                                  ? const Color(0xFF52CAF5)
                                  : Colors.transparent,
                              blurRadius: 45.0, // soften the shadow
                              spreadRadius: 3.0, //extend the shadow
                              offset: const Offset(
                                17.0, 30.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ],
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
