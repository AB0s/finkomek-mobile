import 'package:flutter/material.dart';
import '../../Widgets/Consultation/ConsultationWidget.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Жоспарланған консультациялар'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
        child: ConsultationWidget(showAll: true),
      ),
    );
  }
}
