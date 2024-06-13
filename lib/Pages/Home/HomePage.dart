import 'package:Finkomek/Calculators/DebtPayOff.dart';
import 'package:Finkomek/Calculators/RetirementSavings.dart';
import 'package:Finkomek/Calculators/SavingsGoal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Finkomek/Pages/Chat/VideoChatPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Widgets/Consultation/ConsultationWidget.dart';
import '../../Widgets/Course/CourseCard.dart';
import '../../Widgets/Course/SmallCourseCard.dart';
import '../Authorization/LoginPage.dart';
import '../Course/CourseDetail.dart';
import '../User/UserAccount.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            const ListTile(
              title: Text(
                'FINKOMEK',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle_outlined),
              title: Text(
                '$_fname $_lname',
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.2),
              child: ElevatedButton(
                onPressed: _logout,
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color(0xFF0085A1),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const Divider(height: 30,),
            ListTile(
              leading: const Icon(Icons.calculate),
              title: const Text('Қарызды өтеу калькуляторы'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const DebtPayOffCalculatorPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.calculate),
              title: const Text('Зейнетақы жинақ калькуляторы'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const RetirementSavingsCalculatorPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.calculate),
              title: const Text('Жинақ мақсаттарының калькуляторы'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SavingsGoalCalculatorPage()));
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                SvgPicture.asset(
                  'assets/HomePage/education-load.svg',
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
                const SizedBox(width: 30),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Қош келдің, $_fname',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Бүгін не жаңалық?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Алдағы онлайн-кездесулер',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            ConsultationWidget(),
            const SizedBox(height: 20),
            const Text(
              'Топтағы курс',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const CourseDetailPage(courseId: '6655e9252215a242c78740a0'),
                  ),
                );
              },
              child: const CourseCard(
                id: '6655e9252215a242c78740a0',
                title: 'Балаларға арналған қаржылық сауаттылық курсы',
                description: '',
                courseImage: '/assets/course_card1.png',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
