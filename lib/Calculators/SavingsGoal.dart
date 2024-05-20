import 'package:flutter/material.dart';

class SavingsGoalCalculatorPage extends StatefulWidget {
  const SavingsGoalCalculatorPage({Key? key}) : super(key: key);

  @override
  State<SavingsGoalCalculatorPage> createState() =>
      _SavingsGoalCalculatorPageState();
}

class _SavingsGoalCalculatorPageState extends State<SavingsGoalCalculatorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Жинақ мақсаттарының  \nкалькуляторы:',
                style: TextStyle(
                    fontSize: 26,
                    color: Color(0xFF0085A1),
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Күтілетін үнемдеу сомасы',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                decoration: InputDecoration(
                  isDense: true,
                  constraints: BoxConstraints.tight(const Size.fromHeight(40)),
                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  hintText: 'Мөлшерін еңгізіңіз',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Қазіргі жинақтар',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                decoration: InputDecoration(
                  isDense: true,
                  constraints: BoxConstraints.tight(const Size.fromHeight(40)),
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  hintText: 'Мөлшерін еңгізіңіз',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Айлық сақтау мөлшері',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                decoration: InputDecoration(
                  isDense: true,
                  constraints: BoxConstraints.tight(const Size.fromHeight(40)),
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  hintText: 'Мөлшерін еңгізіңіз',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Күтілетін табыс нормасы',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                decoration: InputDecoration(
                  isDense: true,
                  constraints: BoxConstraints.tight(const Size.fromHeight(40)),
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  hintText: 'Мөлшерін еңгізіңіз',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Жинақ табысының басқа көздері',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                decoration: InputDecoration(
                  isDense: true,
                  constraints: BoxConstraints.tight(const Size.fromHeight(40)),
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  hintText: 'Мөлшерін еңгізіңіз',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF00343F)),
                    onPressed: () {},
                    child: const Text(
                      'Есептеу',
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
