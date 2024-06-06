import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  final String expertName;

  const SuccessPage({Key? key, required this.expertName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Тапсырыс жасау'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'Тапсырыс жасағаныңызға рахмет!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Сіз “$expertName” маманымен консультацияға жазылдыңыз. Консультацияны көру үшін жеке парақшаңызға өтіңіз.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Жеке парақшаға өту'),
            ),
          ],
        ),
      ),
    );
  }
}
