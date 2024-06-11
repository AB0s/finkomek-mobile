import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'Success.dart';

class CheckoutPage extends StatefulWidget {
  final String courseId;
  final String courseName;
  final double coursePrice;
  final double courseRating;
  final String courseType;
  final VoidCallback onCoursePurchased;

  const CheckoutPage({
    Key? key,
    required this.courseId,
    required this.courseName,
    required this.coursePrice,
    required this.courseRating,
    required this.courseType,
    required this.onCoursePurchased,
  }) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final emailController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cvvController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  Future<void> buyCourse(BuildContext context, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User token not found')),
      );
      return;
    }

    final url = 'https://kamal-golang-back-b154d239f542.herokuapp.com/user/buy-course/${widget.courseId}';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode < 299) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Курс сәтті сатып алынды'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).size.height * 0.15,
            ),
          ),
        );
        widget.onCoursePurchased();
        await sendPurchaseMessage(email, context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessPage(courseName: widget.courseName),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Курсты сатып алу мүмкін болмады'),
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

  Future<void> sendPurchaseMessage(String email, BuildContext context) async {
    const url = 'https://kamal-golang-back-b154d239f542.herokuapp.com/api/send-msg';
    final message = 'Құттықтаймыз, Сіз “${widget.courseName}” курсын сатып алдыңыз.';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'To': email,
          'Msg': message,
        }),
      );

      if (response.statusCode < 299) {
        print('Purchase confirmation email sent');
      } else {
        print('Email not sent');
      }
    } catch (e) {
      print('An error occurred while sending email');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    widget.courseRating.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.video_label, color: Colors.black),
                  const SizedBox(width: 4),
                  Text(
                    widget.courseType,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.courseName,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Курс бағасы: ${widget.coursePrice} тг',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Соңғы баға: ${widget.coursePrice} тг',
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
                    buyCourse(context, emailController.text);
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