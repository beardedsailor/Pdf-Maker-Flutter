import 'package:flutter/material.dart';
import 'package:photo_editor_app/screens/homePage.dart';
import 'package:photo_editor_app/utils/custom_colors.dart';

///BottomBar Navigation class.
///Loaded when user auth details are correct
class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int currentIndex = 0;

  ///Children are the page links(Homepage as first in tab bar). to display the page when tapped.
  final List<Widget> _children = [
    HomePage(),
  ];

  ///Function call when user tap on the bottom bar
  void onTappedBar(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  ///initState to initialize before class
  @override
  void initState() {
    
    super.initState();
  }

  ///dispose to delete objects after class
  @override
  void dispose() {
    super.dispose();
  }

  /// display logic build
  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context);
    return Scaffold(
      body: _children[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTappedBar,
        currentIndex: currentIndex,
        selectedItemColor: CustomColors.themeOrange,
        unselectedItemColor: CustomColors.themeBlue,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
