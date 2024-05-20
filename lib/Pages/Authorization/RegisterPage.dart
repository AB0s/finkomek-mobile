import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'LoginPage.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;
  bool _isCodeSent = false;
  String _errorMessage = '';
  String _codeMessage = '';

  @override
  void initState() {
    super.initState();
    _codeController.addListener(_checkCodeEntered);
  }

  @override
  void dispose() {
    _codeController.removeListener(_checkCodeEntered);
    _emailController.dispose();
    _passwordController.dispose();
    _fnameController.dispose();
    _lnameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _checkCodeEntered() {
    setState(() {
      _isCodeSent = _codeController.text.isNotEmpty;
    });
  }

  Future<void> _sendVerificationCode() async {
    setState(() {
      _codeMessage = '';
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('https://kamal-golang-back-b154d239f542.herokuapp.com/auth/send-email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': _emailController.text}),
    );

    setState(() {
      _isLoading = false;
      if (response.statusCode == 200) {
        _isCodeSent = true;
        _codeMessage = 'Code sent to your email';
      } else {
        _codeMessage = 'Failed to send verification code';
      }
    });
  }

  Future<void> _registerWithCode() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final verifyResponse = await http.post(
      Uri.parse('https://kamal-golang-back-b154d239f542.herokuapp.com/auth/check-code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': _emailController.text, 'code': _codeController.text}),
    );

    if (verifyResponse.statusCode == 204) {
      final registerResponse = await http.post(
        Uri.parse('https://kamal-golang-back-b154d239f542.herokuapp.com/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text,
          'password': _passwordController.text,
          'fname': _fnameController.text,
          'lname': _lnameController.text,
        }),
      );

      if (registerResponse.statusCode == 200 || registerResponse.statusCode == 201) {
        final Map<String, dynamic> responseBody = jsonDecode(registerResponse.body);
        if (responseBody['status'] == 'success') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
          print(responseBody['status']);
        } else {
          setState(() {
            _errorMessage = responseBody['message'] ?? 'Registration failed';
            print(responseBody);
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to register';
          print(registerResponse.body);
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Invalid verification code';
        print(verifyResponse.statusCode);
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _registerWithoutCode() async {
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
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
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _codeController,
                      decoration: InputDecoration(labelText: 'Verification Code'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _sendVerificationCode,
                    child: Text('Send Code'),
                  ),
                ],
              ),
              Text(
                _codeMessage,
                style: TextStyle(color: _codeMessage.contains('Failed') ? Colors.red : Colors.green),
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
                    onPressed: _isCodeSent ? _registerWithCode : null,
                    child: Text('Register with Code'),
                  ),
                  ElevatedButton(
                    onPressed: _registerWithoutCode,
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
