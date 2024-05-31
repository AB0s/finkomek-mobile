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
                  for (var i = 0; i < courseContent['modules'].length; i++)
                    ListView.builder(
                      itemCount: courseContent['modules'][i]['lessons'].length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Модуль ${i + 1}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                        var lesson = courseContent['modules'][i]['lessons'][index - 1];
                        return LessonCard(
                          lesson: lesson,
                          lessonIndex: index,
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

class LessonCard extends StatefulWidget {
  final Map<String, dynamic> lesson;
  final int lessonIndex;

  const LessonCard({Key? key, required this.lesson, required this.lessonIndex})
      : super(key: key);

  @override
  _LessonCardState createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Урок ${widget.lessonIndex}: ${widget.lesson['lesson_name']}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (widget.lesson['lesson_type'] == 'vid' &&
                widget.lesson['video_path'].isNotEmpty)
              Container(
                height: 200,
                color: Colors.black,
                child: Center(
                  child: Text(
                    'Video: ${widget.lesson['video_path']}',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            if (widget.lesson['lesson_type'] == 'article')
              AnimatedCrossFade(
                firstChild: _buildCollapsedContent(),
                secondChild: _buildExpandedContent(),
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            if (widget.lesson['lesson_type'] == 'article')
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsedContent() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 100.0), // Set a maximum height for collapsed content
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildExpandedContent() {
    return _buildContent();
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...widget.lesson['lesson_content'].map<Widget>((content) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(content['paragraph']),
            );
          }).toList(),
        ],
      ),
    );
  }
}
