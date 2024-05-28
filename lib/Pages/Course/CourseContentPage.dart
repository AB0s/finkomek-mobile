import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CourseContentPage extends StatefulWidget {
  final String courseId;

  const CourseContentPage({Key? key, required this.courseId}) : super(key: key);

  @override
  _CourseContentPageState createState() => _CourseContentPageState();
}

class _CourseContentPageState extends State<CourseContentPage> {
  bool isLoading = true;
  Map<String, dynamic> courseContent = {};

  @override
  void initState() {
    super.initState();
    fetchCourseContent();
  }

  Future<void> fetchCourseContent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      // Handle the case where the token is not available
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User token not found')),
      );
      return;
    }

    final url = 'https://kamal-golang-back-b154d239f542.herokuapp.com/user/${widget.courseId}';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        if (data['status'] == 'success') {
          setState(() {
            courseContent = data['course'];
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
        title: Text(courseContent['name'] ?? 'Course Content'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : DefaultTabController(
        length: courseContent['modules']?.length ?? 0,
        child: Column(
          children: [
            TabBar(
              isScrollable: true,
              tabs: [
                for (var module in courseContent['modules'])
                  Tab(text: module['module_name']),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  for (var module in courseContent['modules'])
                    ListView.builder(
                      itemCount: module['lessons'].length,
                      itemBuilder: (context, index) {
                        var lesson = module['lessons'][index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Урок ${index + 1}: ${lesson['lesson_name']}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  if (lesson['lesson_type'] == 'vid' &&
                                      lesson['video_path'].isNotEmpty)
                                    Container(
                                      height: 200,
                                      color: Colors.black,
                                      child: Center(
                                        child: Text(
                                          'Video: ${lesson['video_path']}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (lesson['lesson_type'] == 'article')
                                    ...lesson['lesson_content']
                                        .map<Widget>((content) {
                                      return Padding(
                                        padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                        child: Text(content['paragraph']),
                                      );
                                    }).toList(),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
