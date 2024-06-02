import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:llf/Pages/User/UserAccount.dart';
import '../Widgets/Base/BottomNavBar.dart';
import 'Course/CoursesPage.dart';
import 'Home/HomePage.dart';

class MainPage extends StatefulWidget {

  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _widgetOptions() {
    return <Widget>[
      HomePage(),
      CoursesPage(),
      UserAccountPage(),
      PlaceholderWidget(Colors.blue),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions().elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavBar(
        onItemTapped: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  PlaceholderWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}
