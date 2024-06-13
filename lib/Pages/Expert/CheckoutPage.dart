import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:email_validator/email_validator.dart';
import 'ExpertDetail.page.dart';

class CheckoutPage extends StatefulWidget {
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

  Future<void> bookConsultation(BuildContext context, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User token not found')),
      );
      return;
    }

    final url =
        'https://kamal-golang-back-b154d239f542.herokuapp.com/user/meeting/make-appointment';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'roomId': widget.roomId,
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
          widget.onBookingSuccess();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ExpertDetailPage(expertId: widget.expert['Id']),
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
    DateTime startTime = DateTime.parse(widget.meetingTime['timeStart']);
    DateTime endTime = DateTime.parse(widget.meetingTime['timeEnd']);

    String formattedDate = DateFormat('dd MMMM yyyy', 'ru').format(startTime);
    String formattedTime =
        '${DateFormat.Hm('ru').format(startTime)} - ${DateFormat.Hm('ru').format(endTime)}';

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
                    Icon(Icons.calendar_today, color: Color(0xFF0085A1)),
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
                    Icon(Icons.access_time, color:Color(0xFF0085A1)),
                    SizedBox(width: 8),
                    Text(
                      formattedTime,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  '${widget.expert['firstName']} ${widget.expert['lastName']} маманымен консультация',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  'Консультация бағасы: ${widget.expert['cost']} тг',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Соңғы баға: ${widget.expert['cost']} тг',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
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
                        width: 2.0, // Increased border width
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: isEmailValid ? Colors.green : Colors.black,
                        width: 1.0, // Increased border width
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: isEmailValid ? Colors.green : Color(0xFF0085A1),
                        width: 2.3, // Increased border width
                      ),
                    ),
                    errorText:
                        emailError != null && !isEmailValid ? emailError : null,
                    helperText: isEmailValid ? emailError : null,
                    helperStyle: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                    errorStyle: TextStyle(fontWeight: FontWeight.bold),
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
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  keyboardType: TextInputType.number,
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
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: cvvController,
                        decoration: InputDecoration(
                          labelText: 'CVV*',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
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
                      if (_formKey.currentState!.validate()) {
                        bookConsultation(context, emailController.text);
                      }
                    },
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
