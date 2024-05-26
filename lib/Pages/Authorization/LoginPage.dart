import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/CustomBanner.dart';
import '../HomePage.dart';
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

  @override
  void initState() {
    super.initState();
    if (widget.showBanner) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showLoginSuccessBanner();
      });
    }
  }

  void _showLoginSuccessBanner() {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => const Positioned(
        top: kToolbarHeight + 20,
        left: 0,
        right: 0,
        child: SuccessBanner(
            message: 'Вы зарегистрированы,теперь \n войдите в свой аккаунт'),
      ),
    );

    overlayState?.insert(overlayEntry);

    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
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
          MaterialPageRoute(
              builder: (context) => HomePage(showLoginSuccess: true)),
        );
      } else {
        setState(() {
          _errorMessage = responseBody['message'];
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Failed to login';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                  ),
            SizedBox(height: 20),
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text('Don\'t have an account? Register'),
            ),
          ],
        ),
      ),
    );
  }
}
