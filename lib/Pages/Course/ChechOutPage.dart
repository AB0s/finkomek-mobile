import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
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
  final _formKey = GlobalKey<FormState>();
  String? emailError;
  bool isEmailValid = false;

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

    final url =
        'https://kamal-golang-back-b154d239f542.herokuapp.com/user/buy-course/${widget.courseId}';
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
    const url =
        'https://kamal-golang-back-b154d239f542.herokuapp.com/api/send-msg';
    final message =
        'Құттықтаймыз, Сіз “${widget.courseName}” курсын сатып алдыңыз.';

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

  void _validateEmail(String value) {
    setState(() {
      if (EmailValidator.validate(value)) {
        emailError = 'Жарамды пошта';
        isEmailValid = true;
      } else {
        emailError = 'Жарамсыз пошта';
        isEmailValid = false;
      }
    });
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
          child: Form(
            key: _formKey,
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
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Пошта',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: isEmailValid ? Colors.green : Colors.black,
                        width: 2.0,  // Increased border width
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: isEmailValid ? Colors.green : Colors.black,
                        width: 2.0,  // Increased border width
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: isEmailValid ? Colors.green : Color(0xFF0085A1),
                        width: 2.0,  // Increased border width
                      ),
                    ),
                    errorText: emailError != null && !isEmailValid ? emailError : null,
                    helperText: isEmailValid ? emailError : null,
                    helperStyle: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),  // Bold helper text
                    errorStyle: const TextStyle(fontWeight: FontWeight.bold),  // Bold error text
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: _validateEmail,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Поштаны енгізіңіз';
                    } else if (!EmailValidator.validate(value)) {
                      return 'Жарамсыз пошта';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: cardNumberController,
                  decoration: InputDecoration(
                      labelText: 'Карта нөмірі*',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14))),
                  keyboardType: TextInputType.number,
                  inputFormatters: [CreditCardNumberInputFormatter()],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: expiryDateController,
                        decoration: InputDecoration(
                            labelText: 'Мерзімі*',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14))),
                        keyboardType: TextInputType.datetime,
                        inputFormatters: [CreditCardExpirationDateFormatter()],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: cvvController,
                        decoration: InputDecoration(
                            labelText: 'CVV*',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14))),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        inputFormatters: [CreditCardCvcInputFormatter()],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        buyCourse(context, emailController.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF0E7C9F),
                    ),
                    child: const Text('Сатып алу'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
