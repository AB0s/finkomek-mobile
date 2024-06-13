import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class RetirementSavingsCalculatorPage extends StatefulWidget {
  const RetirementSavingsCalculatorPage({Key? key}) : super(key: key);

  @override
  State<RetirementSavingsCalculatorPage> createState() =>
      _RetirementSavingsCalculatorPageState();
}

class _RetirementSavingsCalculatorPageState
    extends State<RetirementSavingsCalculatorPage> {
  TextEditingController _currentAgeController = TextEditingController();
  TextEditingController _retirementAgeController = TextEditingController();
  TextEditingController _currentSavingsController = TextEditingController();
  TextEditingController _annualContributionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Зейнетақы жинақ калькуляторы',
                style: TextStyle(
                    fontSize: 26,
                    color: Color(0xFF0085A1),
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Қазіргі және зейнеткерлік жас',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: TextField(
                      controller: _currentAgeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        isDense: true,
                        constraints:
                        BoxConstraints.tight(const Size.fromHeight(40)),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10))),
                        hintText: 'Қазіргі жас',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: TextField(
                      controller: _retirementAgeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        isDense: true,
                        constraints:
                        BoxConstraints.tight(const Size.fromHeight(40)),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        hintText: 'Зейнеткерлік жас',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Ағымдағы зейнетақы жинақтары',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: _currentSavingsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  isDense: true,
                  prefix: const Text('₸ '),
                  constraints:
                  BoxConstraints.tight(const Size.fromHeight(40)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: 'Соманы енгізіңіз',
                ),
                inputFormatters: [
                  CurrencyInputFormatter(),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Жалақыныз',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: _annualContributionController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  isDense: true,
                  prefix: const Text('₸ '),
                  constraints:
                  BoxConstraints.tight(const Size.fromHeight(40)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: 'Соманы енгізіңіз',
                ),
                inputFormatters: [
                  CurrencyInputFormatter(),
                ],
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00343F),
                  ),
                  onPressed: () {
                    calculateRetirementSavings();
                  },
                  child: const Text(
                    'Есептеу',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void calculateRetirementSavings() {
    double currentSavings = double.tryParse(
        _currentSavingsController.text.replaceAll(',', '')) ??
        0.0;
    double annualContribution = double.tryParse(
        _annualContributionController.text.replaceAll(',', '')) ??
        0.0;

    int yearsUntilRetirement =
        int.tryParse(_retirementAgeController.text)! - int.tryParse(_currentAgeController.text)!;

    double futureValue =
        currentSavings + (yearsUntilRetirement*12)*(annualContribution*0.1);

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
                    title: const Text('Болашақ сома'),
                    trailing: Text(
                      '${futureValue.toInt()}',
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
