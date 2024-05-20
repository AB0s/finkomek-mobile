import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class ExpertDetailPage extends StatefulWidget {
  const ExpertDetailPage({Key? key}) : super(key: key);

  @override
  State<ExpertDetailPage> createState() => _ExpertDetailPageState();
}

class _ExpertDetailPageState extends State<ExpertDetailPage> {
  final Map<String, String> russianTranslations = {
    'January': 'Январь',
    'February': 'Февраль',
    'March': 'Март',
    'April': 'Апрель',
    'May': 'Май',
    'June': 'Июнь',
    'July': 'Июль',
    'August': 'Август',
    'September': 'Сентябрь',
    'October': 'Октябрь',
    'November': 'Ноябрь',
    'December': 'Декабрь',
    'Mon': 'Пн',
    'Tue': 'Вт',
    'Wed': 'Ср',
    'Thu': 'Чт',
    'Fri': 'Пт',
    'Sat': 'Сб',
    'Sun': 'Вс',
  };

  final Map<DateTime, List<String>> appointmentTimes = {
    DateTime(2024, 5, 20): ['10:00-11:00', '12:00-13:00', '15:00-16:00'],
    DateTime(2024, 5, 21): ['09:00-10:00', '11:00-12:00', '14:00-15:00'],
    DateTime(2024, 5, 22): ['08:00-09:00', '13:00-14:00', '16:00-17:00'],
  };

  DateTime selectedDate = DateTime.now();
  List<String> selectedAppointments = [];

  void onDateChange(DateTime date) {
    setState(() {
      selectedDate = date;
      selectedAppointments = appointmentTimes[date] ?? [];
    });
  }

  void showAppointmentDetails(BuildContext context, String appointmentTime) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Подробности приёма',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Дата: ${formatDateToRussian(selectedDate)}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                'Время: $appointmentTime',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xFF0085A1),
                    ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                          )
                      )
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    // Handle appointment making logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Встреча назначена на $appointmentTime')),
                    );
                  },
                  child: const Text(
                    'Назначить встречу',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String formatDateToRussian(DateTime date) {
    final dayOfWeek = russianTranslations[DateFormat('E').format(date)] ?? '';
    final month = russianTranslations[DateFormat('MMMM').format(date)] ?? '';
    final day = date.day.toString();
    return '$dayOfWeek, $day $month';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: const Text(
                      'Name Surname',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.45,
                      'assets/ExpertsPage/1ExpertsPage.png',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        color: Color(0xFF0085A1),
                        borderRadius: BorderRadius.circular(16)),
                    child: Text(
                      'Байланыска шыгу',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xFF0085A1),
                        borderRadius: BorderRadius.circular(16)),
                    child: const FittedBox(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 26,
                            ),
                            Text(
                              '4.5',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  Text(
                    formatDateToRussian(selectedDate),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DatePicker(
                    DateTime.now(),
                    width: 80,
                    height: 100,
                    initialSelectedDate: selectedDate,
                    selectionColor: Color(0xFF0085A1),

                    dateTextStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    dayTextStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    monthTextStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    onDateChange: onDateChange,
                    locale: 'ru',
                  ),
                  const SizedBox(height: 30),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 3,
                    ),
                    itemCount: selectedAppointments.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => showAppointmentDetails(
                            context, selectedAppointments[index]),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(0xFF0085A1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            selectedAppointments[index],
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
