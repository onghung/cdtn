import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tlubook/views/home/support_screens.dart';
import 'book_home.dart';
import 'books_profile.dart';
import 'favorite_screens.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    BooksHome(),
    FavoriteScreen(),
    SupportScreen(),
    BooksProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        color: Colors.transparent,
        child: GNav(
          gap: 10, // Khoảng cách giữa icon và text
          activeColor: Colors.white, // Màu icon và text khi được chọn (trắng)
          color: Colors.black.withOpacity(0.6), // Màu icon và text khi chưa được chọn (đen mờ)
          backgroundColor: Colors.transparent, // Nền trong suốt cho phần GNav
          tabBackgroundColor: Colors.redAccent.withOpacity(0.6), // Nền khi tab được chọn (đỏ nhạt)
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), // Kích thước padding của tab
          iconSize: 24, // Kích thước icon
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600), // Kích thước text
          duration: const Duration(milliseconds: 300),  // Hiệu ứng chuyển đổi
          tabs: const [
            GButton(
              icon: Icons.home,
              text: "Home",
            ),
            GButton(
              icon: Icons.favorite,
              text: "Wishlist",
            ),
            GButton(
              icon: Icons.support_agent,
              text: "Support",
            ),
            GButton(
              icon: Icons.person,
              text: "Profile",
            ),
          ],
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}