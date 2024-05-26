import 'package:flutter/material.dart';
import 'package:llf/APIs/RegistrationApi.dart';

import '../Pages/Authorization/LoginPage.dart';

class RegistrationProvider with ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  bool isLoading = false;
  bool isCodeSent = false;
  String errorMessage = '';
  String codeMessage = '';

  void checkCodeEntered() {
    isCodeSent = codeController.text.isNotEmpty;
    notifyListeners();
  }

  Future<void> sendVerificationCode() async {
    codeMessage = '';
    isLoading = true;
    notifyListeners();

    final result = await RegistrationApi.sendVerificationCode(emailController.text);

    isLoading = false;
    isCodeSent = result['status'] == 'success';
    codeMessage = result['message'];
    notifyListeners();
  }

  Future<void> registerWithCode(BuildContext context) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    final verifyResult = await RegistrationApi.verifyCode(emailController.text, codeController.text);

    if (verifyResult['status'] == 'success') {
      final registerResult = await RegistrationApi.register(
        emailController.text,
        passwordController.text,
        fnameController.text,
        lnameController.text,
      );

      if (registerResult['status'] == 'success') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen(showBanner: true)),
        );
      } else {
        errorMessage = registerResult['message'];
      }
    } else {
      errorMessage = verifyResult['message'];
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> registerWithoutCode(BuildContext context) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    final registerResult = await RegistrationApi.register(
      emailController.text,
      passwordController.text,
      fnameController.text,
      lnameController.text,
    );

    if (registerResult['status'] == 'success') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen(showBanner: true)),
      );
    } else {
      errorMessage = registerResult['message'];
    }

    isLoading = false;
    notifyListeners();
  }
}
