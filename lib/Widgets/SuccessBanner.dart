import 'package:flutter/material.dart';

class SuccessBanner extends StatelessWidget {
  final String message;

  const SuccessBanner({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      child: Container(
        width: double.infinity,
        color: Colors.green,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
