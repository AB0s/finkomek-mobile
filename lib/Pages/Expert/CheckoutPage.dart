import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'ExpertDetail.page.dart';

class CheckoutPage extends StatelessWidget {
  final Map<String, dynamic> expert;
  final int meetingTimeId;
  final String roomId;
  final dynamic meetingTime;
  final VoidCallback onBookingSuccess;

  const CheckoutPage({
    Key? key,
    required this.expert,
    required this.meetingTimeId,
    required this.roomId,
    required this.meetingTime,
    required this.onBookingSuccess,
  }) : super(key: key);

  Future<void> bookConsultation(BuildContext context, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User token not found')),
      );
      return;
    }

    final url = 'https://kamal-golang-back-b154d239f542.herokuapp.com/user/meeting/make-appointment';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'roomId': roomId,
        }),
      );

      if (response.statusCode < 299) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Консультация сәтті брондалды'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).size.height * 0.15,
              ),
            ),
          );
          onBookingSuccess();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ExpertDetailPage(expertId: expert['Id']),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Консультацияны брондау мүмкін болмады'),
              backgroundColor: Colors.red.withOpacity(0.5),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).size.height * 0.15,
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Консультацияны брондау мүмкін болмады'),
            backgroundColor: Colors.red.withOpacity(0.5),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).size.height * 0.15,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Қате орын алды')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final cardNumberController = TextEditingController();
    final expiryDateController = TextEditingController();
    final cvvController = TextEditingController();

    DateTime startTime = DateTime.parse(meetingTime['timeStart']);
    DateTime endTime = DateTime.parse(meetingTime['timeEnd']);

    String formattedDate = DateFormat('dd MMMM yyyy', 'ru').format(startTime);
    String formattedTime = '${DateFormat.Hm('ru').format(startTime)} - ${DateFormat.Hm('ru').format(endTime)}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Тапсырыс жасау'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Тапсырыс мәліметтері',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    formattedDate,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    formattedTime,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '${expert['firstName']} ${expert['lastName']} маманымен консультация',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Консультация бағасы: ${expert['cost']} тг',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Соңғы баға: ${expert['cost']} тг',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Пошта',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Карта нөмірі*',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: expiryDateController,
                      decoration: const InputDecoration(
                        labelText: 'Мерзімі*',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: cvvController,
                      decoration: const InputDecoration(
                        labelText: 'CVV*',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    bookConsultation(context, emailController.text);
                  },
                  child: const Text('Сатып алу'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
