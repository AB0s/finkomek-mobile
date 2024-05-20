import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indexed/indexed.dart';
import 'package:llf/Widgets/BottomNavBar.dart';
import 'package:llf/Widgets/HomePage/ExpertContainers.dart';
import 'package:llf/Widgets/HomePage/HomePageAppBar.dart';
import 'package:llf/Widgets/HomePage/HomePageCarouselSlider.dart';
import 'package:llf/Widgets/HomePage/RowOfScreens.dart';
import '../Widgets/CustomBanner.dart';
import 'User/UserAccount.dart';

class HomePage extends StatefulWidget {
  final bool showLoginSuccess;

  const HomePage({Key? key, this.showLoginSuccess = false}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    if (widget.showLoginSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showLoginSuccessBanner();
      });
    }
  }

  void _showLoginSuccessBanner() {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => const Positioned(
        top: kToolbarHeight+20,
        left: 0,
        right: 0,
        child: SuccessBanner(message: 'Вы зарегистрированы'),
      ),
    );

    overlayState?.insert(overlayEntry);

    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFd9edf1),
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: HomePageAppBar()),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Indexer(
                  children: [
                    Indexed(
                      index: 100,
                      child: SizedBox(
                        width: double.infinity,
                        child: Image.asset(
                          'assets/Group 358 (2).png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Indexed(
                      index: 200,
                      child: RowOfScreens(),
                    ),
                    const Indexed(
                      index: 0,
                      child: HomePageCarouselSlider(),
                    ),
                    const Indexed(
                      index: 300,
                      child: ExpertContainers(),
                    ),
                  ],
                ),
                Container(
                  color: Colors.white,
                  width: 100,
                  height: 100,
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
