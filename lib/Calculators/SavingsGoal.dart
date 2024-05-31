import 'package:flutter/material.dart';

class SavingsGoalCalculatorPage extends StatefulWidget {
  const SavingsGoalCalculatorPage({Key? key}) : super(key: key);

  @override
  State<SavingsGoalCalculatorPage> createState() =>
      _SavingsGoalCalculatorPageState();
}

class _SavingsGoalCalculatorPageState extends State<SavingsGoalCalculatorPage> {
  TextEditingController _sumController = TextEditingController();
  TextEditingController _currentSavingsController = TextEditingController();
  TextEditingController _monthlySavingsControler = TextEditingController();

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
                controller: _sumController,
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
                controller: _currentSavingsController,
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
                controller: _monthlySavingsControler,
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
                    onPressed: () {calculateSavingsGoal();},
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
  void calculateSavingsGoal() {

    double sumSavings = double.tryParse(
        _sumController.text.replaceAll(',', '')) ??
        0.0;

    double currentSavings = double.tryParse(
        _currentSavingsController.text.replaceAll(',', '')) ??
        0.0;
    double monthlySavings = double.tryParse(
        _monthlySavingsControler.text.replaceAll(',', '')) ??
        0.0;

    double futureTime =
    (sumSavings-currentSavings)/monthlySavings;
    print(futureTime);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.35,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: const Text('Айлар саны'),
                    trailing: Text(
                      '${futureTime.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
