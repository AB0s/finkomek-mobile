import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class NetWorthCalculatorPage extends StatefulWidget {
  const NetWorthCalculatorPage({Key? key}) : super(key: key);

  @override
  State<NetWorthCalculatorPage> createState() => _NetWorthCalculatorPageState();
}

class _NetWorthCalculatorPageState extends State<NetWorthCalculatorPage> {
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
            children: [
              const Text(
                'Таза құн \nкалькуляторы:',
                style: TextStyle(
                    fontSize: 26,
                    color: Color(0xFF0085A1),
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Карыз туры'),
              const SizedBox(
                height: 10,
              ),
              DropdownMenu<String>(
                width: MediaQuery.of(context).size.width * 0.9,
                dropdownMenuEntries: const [
                  DropdownMenuEntry<String>(
                    label: 'Ипотека',
                    value: 'Ипотека',
                  ),
                  DropdownMenuEntry<String>(
                    label: 'Кредит',
                    value: 'Кредит',
                  ),
                ],
                hintText: 'Танданыз',
                inputDecorationTheme: InputDecorationTheme(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  constraints: BoxConstraints.tight(const Size.fromHeight(40)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
