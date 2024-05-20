import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'LoginPage.dart';
import 'VerifyCodePage.dart'; // Import the VerifyCodePage

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _register({bool withCode = false}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final response = await http.post(
      Uri.parse('https://kamal-golang-back-b154d239f542.herokuapp.com/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': _emailController.text,
        'password': _passwordController.text,
        'fname': _fnameController.text,
        'lname': _lnameController.text,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody['status'] == 'success') {
        if (withCode) {
          await _sendVerificationCode();
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      } else {
        setState(() {
          _errorMessage = responseBody['message'] ?? 'Registration failed';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Failed to register';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _sendVerificationCode() async {
    final response = await http.post(
      Uri.parse('https://kamal-golang-back-b154d239f542.herokuapp.com/auth/send-email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': _emailController.text}),
    );

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyCodePage(email: _emailController.text),
        ),
      );
    } else {
      setState(() {
        _errorMessage = 'Failed to send verification code';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              TextField(
                controller: _fnameController,
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: _lnameController,
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _register(withCode: true),
                    child: Text('Register with Code'),
                  ),
                  ElevatedButton(
                    onPressed: () => _register(withCode: false),
                    child: Text('Register without Code'),
                  ),
                ],
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
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text('Have an account? Log in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
