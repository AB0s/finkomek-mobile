import 'package:flutter/material.dart';
import 'package:Finkomek/Widgets/Course/CourseCard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Models/Course.dart';
import 'CourseDetail.dart'; // Add this import

class CoursesPage extends StatefulWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  List<Course> courses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    const url =
        'https://kamal-golang-back-b154d239f542.herokuapp.com/course/get-all-courses';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json
            .decode(utf8.decode(response.bodyBytes)); // Ensure UTF-8 encoding
        if (data['status'] == 'success') {
          setState(() {
            courses = (data['courses'] as List)
                .map((courseJson) => Course.fromJson(courseJson))
                .toList();
            isLoading = false;
          });
        } else {
          // Handle error
          setState(() {
            isLoading = false;
          });
        }
      } else {
        // Handle error
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle error
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Финтех Курстарымен танысыңыз',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Оқу жолыңызды таңдаңыз, дағдыларыңызды дамытыңыз және біліміңізді шыңдаңыз. Барлығы бір жерде.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    primary: false,
                    shrinkWrap: true,
                    itemCount: courses.length,
                    itemBuilder: (BuildContext context, int index) {
                      final course = courses[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CourseDetailPage(courseId: course.id),
                            ),
                          );
                        },
                        child: CourseCard(
                          id:course.id,
                          title: course.name,
                          description: course.shortDescription,
                          courseImage: course.imageUrl,
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5)),
                  ),
                ],
              ),
            ),
    );
  }
}
