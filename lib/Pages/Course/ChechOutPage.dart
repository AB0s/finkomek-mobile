import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:async';

class CheckoutPage extends StatelessWidget {
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

  Future<void> buyCourse(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User token not found')),
      );
      return;
    }

    final url =
        'https://kamal-golang-back-b154d239f542.herokuapp.com/user/buy-course/$courseId';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode < 299) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course purchased successfully')),
        );
        onCoursePurchased();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to purchase course')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final cardNumberController = TextEditingController();
    final expiryDateController = TextEditingController();
    final cvvController = TextEditingController();

    bool validateEmail() {
      final bool isValid = EmailValidator.validate(emailController.text.trim());
      if (isValid) {
        ScaffoldMessenger.of(context).showMaterialBanner(
          MaterialBanner(
            content: Text('Дурыс email'),
            actions: [SizedBox()],
            backgroundColor: Colors.green.withOpacity(0.6),
            onVisible: () {
              Future.delayed(Duration(seconds: 2), () {
                ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
              });
            },
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showMaterialBanner(
            MaterialBanner(
              content: Text('Дурыс емес email'),
              actions: [SizedBox()],
              backgroundColor: Colors.red.withOpacity(0.5),
              onVisible: () {
                Future.delayed(Duration(seconds: 2), () {
                  ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
                });
              },
            ),
        );
      }
      return isValid;
    }

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
                    courseRating.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.video_label, color: Colors.black),
                  const SizedBox(width: 4),
                  Text(
                    courseType,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                courseName,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Курс бағасы: $coursePrice тг',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Соңғы баға: $coursePrice тг',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                inputFormatters: [CreditCardNumberInputFormatter()],
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
                      inputFormatters: [CreditCardExpirationDateFormatter()],
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
                      inputFormatters: [CreditCardCvcInputFormatter()],
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
                    validateEmail() == true ? buyCourse(context) : null;
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
