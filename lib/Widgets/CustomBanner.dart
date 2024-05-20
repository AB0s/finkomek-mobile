import 'package:flutter/material.dart';

class SuccessBanner extends StatefulWidget {
  final String message;
  final Duration duration;

  const SuccessBanner(
      {Key? key,
      required this.message,
      this.duration = const Duration(seconds: 3)})
      : super(key: key);

  @override
  _SuccessBannerState createState() => _SuccessBannerState();
}

class _SuccessBannerState extends State<SuccessBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();

    Future.delayed(widget.duration, () {
      if (mounted) {
        _controller.reverse().then((_) {
          if (mounted) {
            Navigator.of(context).pop();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Material(
        elevation: 10,
        child: Container(
          width: double.infinity,
          color: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: Text(
            widget.message,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
