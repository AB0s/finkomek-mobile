import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Finkomek/Calculators/DebtPayOff.dart';
import 'package:Finkomek/Calculators/RetirementSavings.dart';
import 'package:Finkomek/Calculators/SavingsGoal.dart';

import '../../Calculators/NetWorth.dart';

class CalculatorsPage extends StatefulWidget {
  const CalculatorsPage({Key? key}) : super(key: key);

  @override
  State<CalculatorsPage> createState() => _CalculatorsPageState();
}

class _CalculatorsPageState extends State<CalculatorsPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<String> Title = <String>[
    'Таза құн  \nкалькуляторы:',
    'Қарызды өтеу \nкалькуляторы',
    'Зейнетақы жинақ \nкалькуляторы',
    'Жинақ \nмақсаттарының \nкалькуляторы',
  ];
  final List<String> SubTitle = <String>[
    'Сіз өз баганызды білесіз бе?',
    'Ипотека, несие - сіз айтасыз! Мен сізге барлық нюанстарға қатысты ай сайынғыv шығындарды есептеуге көмектесе аламын',
    'Сіздің үкіметіңіз сізді\nзейнетақымен қамтамасыз етті ме? - Проблема жоқ!',
    'Алдын ала жоспарлау есептеулерді \nқажет етеді',
  ];
  final List<int> colorCodes = [0xFF0085A1, 0xFF00343F, 0xFFFFCA03, 0xFF0085A1];

  final List<String> CourseImages= <String>[
    'assets/course_card1.svg',
    'assets/course_card2.svg',
    'assets/3Course.svg',
    'assets/1Course.svg',
  ];
  final List<Widget> CalculatorPages = <Widget>[
    NetWorthCalculatorPage(),
    DebtPayOffCalculatorPage(),
    RetirementSavingsCalculatorPage(),
    SavingsGoalCalculatorPage(),
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
            const Text('Калькуляторлар',
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
                itemCount: Title.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    child: Container(
                      height: 190,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(colorCodes[index]),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, left: 15),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 185,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Title[index],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                  const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                                  Text(
                                    SubTitle[index],
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Padding(
                              padding: const EdgeInsets.only(),
                              child: SvgPicture.asset(CourseImages[index], width: 100,height: 80,),
                            )
                          ],
                        ),
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => CalculatorPages[index]));
                    },
                  );
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
