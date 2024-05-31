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
                'Retirement savings calculator',
                style: TextStyle(
                    fontSize: 26,
                    color: Color(0xFF0085A1),
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Current and retirement ages',
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
                        hintText: 'Current age',
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
                        hintText: 'Retirement age',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Current pension savings',
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
                  constraints:
                  BoxConstraints.tight(const Size.fromHeight(40)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: 'Enter the amount',
                ),
                inputFormatters: [
                  CurrencyInputFormatter(),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Monthly storage volume',
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
                  constraints:
                  BoxConstraints.tight(const Size.fromHeight(40)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: 'Enter the amount',
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
                    double result = calculateRetirementSavings();
                    // Do something with the result, like displaying it in a dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Retirement Savings'),
                          content: Text('Your retirement savings will be ${result.toStringAsFixed(2)}'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Calculate',
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

  double calculateRetirementSavings() {
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

    return futureValue;
  }
}
