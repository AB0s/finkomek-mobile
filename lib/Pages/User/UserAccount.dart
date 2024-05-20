import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'UserSettings.dart';
import '../Authorization/LoginPage.dart';
import '../../Widgets/UserAccountTabbar.dart';

class UserAccountPage extends StatefulWidget {
  const UserAccountPage({Key? key}) : super(key: key);

  @override
  State<UserAccountPage> createState() => _UserAccountPageState();
}

class _UserAccountPageState extends State<UserAccountPage>
    with TickerProviderStateMixin {
  String _email = '';
  String _fname = '';
  String _lname = '';

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('email') ?? '';
      _fname = prefs.getString('fname') ?? '';
      _lname = prefs.getString('lname') ?? '';
    });
  }

  Future<void> _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('email');
    await prefs.remove('fname');
    await prefs.remove('lname');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserSettingsPage()),
              );
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(40),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 50,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.13,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$_fname \n$_lname',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF0085A1),
                      ),
                    ),
                    Text(_email),
                    const Text('+77777777'),
                    const SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: _logout,
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              // Change your radius here
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFF0085A1)),
                        ),
                        child: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ), // Placeholder for phone number
                  ],
                )
              ],
            ),
          ),
          const UserAccountTabbar(),
        ],
      ),
    );
  }
}
