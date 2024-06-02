import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/Course/VideoPlayerWidget.dart';

class CourseContentPage extends StatefulWidget {
  final String courseId;

  const CourseContentPage({Key? key, required this.courseId}) : super(key: key);

  @override
  _CourseContentPageState createState() => _CourseContentPageState();
}

class _CourseContentPageState extends State<CourseContentPage> {
  bool isLoading = true;
  Map<String, dynamic> courseContent = {};
  int currentModuleIndex = 0;
  int currentLessonIndex = 0;

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

    final url =
        'https://kamal-golang-back-b154d239f542.herokuapp.com/user/${widget.courseId}';
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

  void goToPreviousLesson() {
    setState(() {
      if (currentLessonIndex > 0) {
        currentLessonIndex--;
      } else if (currentModuleIndex > 0) {
        currentModuleIndex--;
        currentLessonIndex =
            courseContent['modules'][currentModuleIndex]['lessons'].length - 1;
      }
    });
  }

  void goToNextLesson() {
    setState(() {
      if (currentLessonIndex <
          courseContent['modules'][currentModuleIndex]['lessons'].length - 1) {
        currentLessonIndex++;
      } else if (currentModuleIndex < courseContent['modules'].length - 1) {
        currentModuleIndex++;
        currentLessonIndex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    bool isLastLesson = currentModuleIndex ==
            courseContent['modules'].length - 1 &&
        currentLessonIndex ==
            courseContent['modules'][currentModuleIndex]['lessons'].length - 1;

    var currentModule = courseContent['modules'][currentModuleIndex];
    var currentLesson = currentModule['lessons'][currentLessonIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('${currentModuleIndex + 1} Бөлім: ${currentModule['module_name']}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isLastLesson) ...[
              Center(
                child: Text(
                  '${currentLessonIndex + 1}. ${currentLesson['lesson_name']}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: currentLesson['lesson_type'] == 'article'? Text(
                        currentLesson['lesson_content']
                            .map((content) => content['paragraph'])
                            .join('\n\n'),
                    style: const TextStyle(fontSize: 16),):VideoPlayerWidget(videoPath: currentLesson['video_path'],)
                ),
              ),
            ] else ...[
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/student-achievement.png',
                          height: 200),
                      // Make sure to add this asset to your project
                      const SizedBox(height: 20),
                      const Text(
                        'Құттықтаймыз!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Сіз курсты аяқтадыңыз',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentLessonIndex == 0 && currentModuleIndex == 0
                      ? null
                      : goToPreviousLesson,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFFE7F4F8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back,
                          color:
                              currentLessonIndex == 0 && currentModuleIndex == 0
                                  ? Colors.grey
                                  : const Color(0xFF0E7C9F)),
                      const SizedBox(width: 8),
                      Text(
                        'Алдыңғы тарау',
                        style: TextStyle(
                            color: currentLessonIndex == 0 &&
                                    currentModuleIndex == 0
                                ? Colors.grey
                                : const Color(0xFF0E7C9F)),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: isLastLesson
                      ? () => Navigator.pop(context)
                      : goToNextLesson,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF0E7C9F),
                  ),
                  child: Row(
                    children: [
                      Text(isLastLesson ? 'Басты бетке өту' : 'Келесі тарау'),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
