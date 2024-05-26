import 'package:flutter/material.dart';
import 'package:llf/Widgets/CourseCard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Models/Course.dart';
import 'CourseDetail.dart';  // Add this import

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
    const url = 'https://kamal-golang-back-b154d239f542.herokuapp.com/course/get-all-courses';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));  // Ensure UTF-8 encoding
        if (data['status'] == 'success') {
          setState(() {
            courses = (data['courses'] as List).map((courseJson) => Course.fromJson(courseJson)).toList();
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
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification button click here
            },
          ),
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
              child: const Padding(
                padding: EdgeInsets.only(left: 30),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Kurstar',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            Container(
              height: 2,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black,
                    Colors.transparent
                  ],
                  stops: [0, 0, 1],
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: courses.length,
                itemBuilder: (BuildContext context, int index) {
                  final course = courses[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseDetailPage(courseId: course.id),
                        ),
                      );
                    },
                    child: CourseCard(
                      title: course.name,
                      description: course.shortDescription,
                      colorCode: 0xFF0085A1,
                      courseImage: 'https://kamal-golang-back-b154d239f542.herokuapp.com' + course.imageUrl,
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
