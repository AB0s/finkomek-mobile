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



class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegistrationProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<RegistrationProvider>(
              builder: (context, provider, child) {
                return Column(
                  children: <Widget>[
                    TextField(
                      controller: provider.emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: provider.codeController,
                            decoration: const InputDecoration(
                                labelText: 'Verification Code'),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: provider.sendVerificationCode,
                          child: const Text('Send Code'),
                        ),
                      ],
                    ),
                    Text(
                      provider.codeMessage,
                      style: TextStyle(
                          color: provider.codeMessage.contains('Failed')
                              ? Colors.red
                              : Colors.green),
                    ),
                    TextField(
                      controller: provider.passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    SizedBox(height: 10,),
                    FlutterPwValidator(
                      controller: provider.passwordController,
                      minLength: 8,
                      uppercaseCharCount: 1,
                      numericCharCount: 2,
                      width: 400,
                      height: 100,
                      onSuccess: () {

                      },
                      onFail: () {

                      },
                      strings: RuStrings(),
                    ),
                    TextField(
                      controller: provider.fnameController,
                      decoration:
                          const InputDecoration(labelText: 'First Name'),
                    ),
                    TextField(
                      controller: provider.lnameController,
                      decoration: const InputDecoration(labelText: 'Last Name'),
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
                                child: Text('Register with Code'),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    provider.registerWithoutCode(context),
                                child: Text('Register without Code'),
                              ),
                            ],
                          ),
                    const SizedBox(height: 20),
                    Text(
                      provider.errorMessage,
                      style: TextStyle(color: Colors.red),
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
                      child: const Text('Have an account? Log in'),
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
