import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class DebtPayOffCalculatorPage extends StatefulWidget {
  const DebtPayOffCalculatorPage({Key? key}) : super(key: key);

  @override
  State<DebtPayOffCalculatorPage> createState() =>
      _DebtPayOffCalculatorPageState();
}

class _DebtPayOffCalculatorPageState extends State<DebtPayOffCalculatorPage> {
  double _currentValue = 20.0;
  TextEditingController _sumController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  double _totalDebt = 0.0;
  double _sum = 0;
  double _time=0;
  String? _selectedDebtType;
  bool _isButtonEnabled = false; // Track button state

  @override
  void dispose() {
    _sumController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _calculateTotalDebt() {
    double sum = double.tryParse(
        _sumController.text.substring(0, _sumController.text.length - 3).replaceAll(',', '')) ??
        0.0;
    double time = double.tryParse(_timeController.text) ?? 0.0;
    double interestRate = _currentValue / 100;

    double totalDebt = sum * (1 + interestRate * time);
    setState(() {
      _totalDebt = totalDebt;
      _sum = sum;
      _time=time;
    });
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
                    title: const Text('Общая сумма'),
                    trailing: Text(
                      '${_totalDebt.toInt()} ₸',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  ListTile(
                    title: const Text('Сумма товара'),
                    trailing: Text('${_sum.toInt()} ₸',
                        style: const TextStyle(fontSize: 16)),
                  ),
                  ListTile(
                    title: const Text('Переплата'),
                    trailing: Text(
                      '${_totalDebt.toInt() - _sum.toInt()} ₸',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  ListTile(
                    title: Text('Айлык толем'),
                    trailing: Text(
                      '${(_totalDebt.toInt() / _time.toInt()).toInt()} ₸',
                      style: const TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  void _checkButtonState() {
    setState(() {
      _isButtonEnabled = _sumController.text.isNotEmpty &&
          _timeController.text.isNotEmpty &&
          _selectedDebtType != null;
    });
  }

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
                'Қарызды өтеу  \nКалькулятор',
                style: TextStyle(
                    fontSize: 26,
                    color: Color(0xFF0085A1),
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Қарыз түрі',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
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
                hintText: 'Таңдау',
                inputDecorationTheme: InputDecorationTheme(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  constraints: BoxConstraints.tight(const Size.fromHeight(40)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onSelected: (value) {
                  setState(() {
                    _selectedDebtType = value;
                    _checkButtonState();
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Сома',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: _sumController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefix: const Text('₸ '),
                  isDense: true,
                  constraints: BoxConstraints.tight(const Size.fromHeight(40)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  hintText: 'Соманы енгізіңіз',
                ),
                inputFormatters: [
                  CurrencyInputFormatter(),
                ],
                onChanged: (value) {
                  _checkButtonState();
                },
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Уақыт (Ай саны)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: _timeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  isDense: true,
                  constraints: BoxConstraints.tight(const Size.fromHeight(40)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  hintText: 'Уақытты енгізіңіз',
                ),
                onChanged: (value) {
                  _checkButtonState();
                },
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Пайыздық мөлшерлемелер',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 10.0,
                ),
                child: Slider(
                  activeColor: Color(0xFF00343F),
                  thumbColor: Color(0xFF00343F),
                  value: _currentValue,
                  min: 0,
                  max: 50,
                  divisions: 50,
                  label: _currentValue.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _currentValue = value;
                    });
                  },
                ),
              ),
              Text(
                'Таңдалған пайыз: ${_currentValue.toInt()}%',
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00343F),
                  ),
                  onPressed: _isButtonEnabled ? _calculateTotalDebt : null,
                  child: const Text(
                    'Есептеу',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
