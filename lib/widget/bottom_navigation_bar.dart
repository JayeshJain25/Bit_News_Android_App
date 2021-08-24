import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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

class _MyCustomBottomNavigationBarState extends State<BottomNavigationBar>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  int previousIndex = 0;

  late AnimationController idleAnimation;
  late AnimationController onSelectedAnimation;
  late AnimationController onChangedAnimation;

  Duration animationDuration = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    idleAnimation = AnimationController(vsync: this);
    onSelectedAnimation =
        AnimationController(vsync: this, duration: animationDuration);
    onChangedAnimation =
        AnimationController(vsync: this, duration: animationDuration);
  }

  @override
  void dispose() {
    super.dispose();
    idleAnimation.dispose();
    onSelectedAnimation.dispose();
    onChangedAnimation.dispose();
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
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color(0xFF4E8799),
        color: Colors.black,
        height: 50,
        animationCurve: Curves.fastOutSlowIn,
        items: <Widget>[
          const ImageIcon(
            AssetImage('lib/assets/market.png'),
            size: 20,
            color: Colors.white,
          ),
          const ImageIcon(
            AssetImage('lib/assets/star.png'),
            size: 20,
            color: Colors.white,
           ),
          // Container(
          //     width: 25,
          //     height: 25,
          //     color: Colors.white,
          //     child: Lottie.asset('lib/lottie/animation1.json',
          //         controller: _currentIndex == 2
          //             ? onSelectedAnimation
          //             : previousIndex == 2
          //                 ? onChangedAnimation
          //                 : idleAnimation)),
          const ImageIcon(
            AssetImage('lib/assets/news.png'),
            size: 20,
            color: Colors.white,
          ),
          const Icon(
            Icons.notifications_outlined,
            size: 20,
            color: Colors.white,
          ),
        ],
        onTap: (index) {
          onSelectedAnimation.reset();
          onSelectedAnimation.forward();

          onChangedAnimation.value = 1;
          onChangedAnimation.reverse();
          setState(() {
            previousIndex = _currentIndex;
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
