import 'package:flutter/material.dart';

import '../../Pages/Calcualtor/CalculatorsPage.dart';
import '../../Pages/ChatPage.dart';
import '../../Pages/Course/CoursesPage.dart';
import '../../Pages/Expert/ExpertsPage.dart';

class RowOfScreens extends StatefulWidget {
  const RowOfScreens({Key? key}) : super(key: key);

  @override
  State<RowOfScreens> createState() => _RowOfScreensState();
}

class _RowOfScreensState extends State<RowOfScreens> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.25),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 12, horizontal: 60),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/Binder.png'),
                    const Text('Courses')
                  ],
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const CoursesPage()));
                },
              ),
              GestureDetector(
                child: Column(
                  children: [
                    Image.asset('assets/Calculator.png'),
                    const Text('Calculators')
                  ],
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          ChatPage()));
                },
              ),
              Column(
                children: [
                  Image.asset('assets/Calendar.png'),
                  const Text('Calendar')
                ],
              ),
              GestureDetector(
                child: const Column(
                  children: [
                    Icon(Icons.people,size: 34,),
                    Text(
                      'Experts',
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const ExpertsPage()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
