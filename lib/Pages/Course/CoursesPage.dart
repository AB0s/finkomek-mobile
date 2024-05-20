import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:llf/Widgets/CourseCard.dart';

import '../../Calculators/NetWorth.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<String> title = <String>[
    'Финанстық қауіпсіздікке кіріспе:',
    'Финанстық қауіпсіздікке кіріспе  ',
    'Финанстық қауіпсіздікке кіріспе',
    'Retirement Savings Calculator'
  ];
  final List<String> subTitle = <String>[
    'Do you know your worth?',
    'I can help you calculate monthly expenses regarding all the nuances',
    'Planning ahead requires calculations',
    'Your government failed you with pensions? - No problemo!'
  ];
  final List<int> colorCodes = [0xFF0085A1, 0xFF00343F, 0xFFFFCA03, 0xFF0085A1];

  final List<String> courseImages = <String>[
    'assets/1Course.svg',
    'assets/2Course.svg',
    'assets/3Course.svg',
    'assets/1Course.svg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification button click here
            },
          ),
        ],
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Padding(
                padding: EdgeInsets.only(left: 30),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Курстар',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            Container(
              height: 2, // Adjust the height of the line
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black,
                    Colors.transparent
                  ],
                  stops: [0, 0, 1],
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: title.length,
                itemBuilder: (BuildContext context, int index) {
                  return CourseCard(
                      title: title[index],
                      description: subTitle[index],
                      colorCode: colorCodes[index], courseImage: courseImages[index],);
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 40,
        selectedItemColor: Color(0xFF339db4),
        unselectedItemColor: Color(0xFFa7dbe5),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: '')
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
