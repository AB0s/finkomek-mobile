import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/Base/CustomBanner.dart';
import '../MainPage.dart';
import 'RegistrationPage.dart';

class LoginScreen extends StatefulWidget {
  final bool showBanner;

  const LoginScreen({Key? key, this.showBanner = false}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';
  late bool _passwordVisible;

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final response = await http.post(
      Uri.parse(
          'https://kamal-golang-back-b154d239f542.herokuapp.com/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody['status'] == 'success') {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', responseBody['token']);
        await prefs.setString('email', responseBody['email']);
        await prefs.setString('fname', responseBody['fname']);
        await prefs.setString('lname', responseBody['lname']);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      } else {
        setState(() {
          _errorMessage = responseBody['message'];
        });
      }
    }
    if (response.statusCode == 400) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody['message'] == 'incorrect email or password') {
        _errorMessage = 'Қате пошта немесе құпия сөз';
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Кіру')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'КІРУ',
              style: TextStyle(
                  color: Color(0xFF0085A1),
                  fontWeight: FontWeight.bold,
                  fontSize: 34),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                  label: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.email_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Электрондық пошта')
                    ],
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14))),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: _passwordController,
              obscureText: !_passwordVisible,
              //This will obscure text dynamically
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                label: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_outline),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Құпия сөз')
                  ],
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF0E7C9F),
                    ),
                    child: const Text('Кіру'),
                  ),
            const SizedBox(height: 20),
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "Аккаунтыңыз жоқ па? ",
                      style:
                          TextStyle(color: Colors.black), // default text color
                    ),
                    TextSpan(
                      text: 'Тіркеліңіз',
                      style: TextStyle(
                          color: Color(
                              0xFF0085A1)), // color of the word you want to change
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
