import 'package:flutter/material.dart';

import '../../Pages/User/UserAccount.dart';


class HomePageAppBar extends StatefulWidget {
  const HomePageAppBar({Key? key}) : super(key: key);

  @override
  State<HomePageAppBar> createState() => _HomePageAppBarState();
}

class _HomePageAppBarState extends State<HomePageAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            // Handle notification button click here
          },
        ),
        IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const UserAccountPage()));
            },
            icon: const Icon(Icons.account_circle_outlined)),
      ],
      flexibleSpace: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                icon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
