import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/RegistrationProvider.dart';
import 'LoginPage.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:flutter_pw_validator/Resource/Strings.dart';

class RuStrings implements FlutterPwValidatorStrings {
  @override
  final String atLeast = 'Минимум - символов';
  @override
  final String normalLetters = "- Букв";
  @override
  final String uppercaseLetters = "- Заглавных букв";
  @override
  final String lowercaseLetters = "- Маленьких букв";
  @override
  final String numericCharacters = "- Цифры";
  @override
  final String specialCharacters = "- Особых знаков";
}

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late bool _passwordVisible;

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegistrationProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Тіркелу'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<RegistrationProvider>(
              builder: (context, provider, child) {
                return Column(
                  children: <Widget>[
                    const Text(
                      'ТІРКЕЛУ',
                      style: TextStyle(
                          color: Color(0xFF0085A1),
                          fontWeight: FontWeight.bold,
                          fontSize: 34),
                    ),
                    SizedBox(height: 15,),
                    TextField(
                      controller: provider.emailController,
                      decoration: InputDecoration(
                          labelText: 'Электрондық пошта',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14))),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: provider.codeController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14)),
                                labelText: 'Растау коды'),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: provider.sendVerificationCode,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFF0E7C9F),
                          ),
                          child: const Text('Код жіберу'),
                        ),
                      ],
                    ),
                    Text(
                      provider.codeMessage,
                      style: TextStyle(
                          color: provider.codeMessage.contains('Сәтсіз')
                              ? Colors.red
                              : Colors.green),
                    ),
                    TextFormField(
                      controller: provider.passwordController,
                      decoration: InputDecoration(
                        labelText: 'Құпия сөз',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
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
                      obscureText: !_passwordVisible,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FlutterPwValidator(
                      controller: provider.passwordController,
                      minLength: 8,
                      uppercaseCharCount: 1,
                      numericCharCount: 2,
                      width: 400,
                      height: 120,
                      onSuccess: () {},
                      onFail: () {},
                      strings: RuStrings(),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: provider.fnameController,
                      decoration: InputDecoration(
                          labelText: 'Аты',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14))),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: provider.lnameController,
                      decoration: InputDecoration(
                          labelText: 'Тегі',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14))),
                    ),
                    const SizedBox(height: 20),
                    provider.isLoading
                        ? const CircularProgressIndicator()
                        : Column(
                            children: [
                              ElevatedButton(
                                onPressed: provider.isCodeSent
                                    ? () => provider.registerWithCode(context)
                                    : null,
                                child: const Text('Кодпен тіркелу'),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  foregroundColor: Colors.white,
                                  backgroundColor: const Color(0xFF0E7C9F),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    provider.registerWithoutCode(context),
                                child: const Text('Кодсыз тіркелу'),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  foregroundColor: Colors.white,
                                  backgroundColor: const Color(0xFF0E7C9F),
                                ),
                              ),
                            ],
                          ),
                    Text(
                      provider.errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Аккаунтыныз бар ма? ',
                              style: TextStyle(
                                  color: Colors.black), // default text color
                            ),
                            TextSpan(
                              text: 'Кіру',
                              style: TextStyle(
                                  color: Color(
                                      0xFF0085A1)), // color of the word you want to change
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
