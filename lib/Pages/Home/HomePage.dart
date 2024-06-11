import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:llf/Pages/Chat/VideoChatPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Widgets/Consultation/ConsultationWidget.dart';
import '../../Widgets/Course/CourseCard.dart';
import '../../Widgets/Course/SmallCourseCard.dart';
import '../User/UserAccount.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _fname = '';

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fname = prefs.getString('fname') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            ListTile(
              title: Text(
                'FINKOMEK',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Аккаунт'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserAccountPage()));
              },
            ),
            ListTile(
              title: Text('Тіл ауыстыру'),
              onTap: () {//61fe1852-9c80-42cc-9f62-135938a7a1e2
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => VideoChatPage()));
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
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
                const SizedBox(
                  width: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.35,
                      child: Text(
                        'Қош келдің, $_fname',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.35,
                      child: const Text(
                        'Бүгін не жаңалық?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            const Text(
              'Алдағы онлайн-кездесулер',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            ConsultationWidget(),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Соңғы өткен курстар',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 20,
            ),
            const CourseCard(
              title: 'Балаларға арналған қаржылық сауаттылық курсы',
              description: '',
              courseImage: '/assets/course_card1.png',
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Жуардағы курстар',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: ListView.separated(
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  return SmallCourseCard();
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    width: 20,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
