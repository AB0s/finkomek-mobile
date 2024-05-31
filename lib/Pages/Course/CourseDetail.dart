import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'CourseContentPage.dart'; // Import the new page
import 'package:flutter_svg/flutter_svg.dart';

class CourseDetailPage extends StatefulWidget {
  final String courseId;

  const CourseDetailPage({Key? key, required this.courseId}) : super(key: key);

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  bool isLoading = true;
  bool isPurchased = false;
  bool _isTapped = false;
  String title = '';
  String description = '';
  String courseImage = '';
  int cost = 0;
  String moduleCount = '';

  @override
  void initState() {
    super.initState();
    fetchCourseDetails();
    checkIfPurchased();
  }

  Future<void> fetchCourseDetails() async {
    final url = 'https://kamal-golang-back-b154d239f542.herokuapp.com/course/${widget.courseId}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        if (data['status'] == 'success') {
          setState(() {
            final course = data['course'];
            title = course['name'];
            description = course['short_description'];
            courseImage = course['image_url'];
            cost = course['cost'];
            moduleCount = course['module_count'];
          });
        } else {
          // Handle error
        }
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle error
    }
    // Fetch purchase status after fetching course details
    checkIfPurchased();
  }

  Future<void> checkIfPurchased() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      // Handle the case where the token is not available
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User token not found')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    final url = 'https://kamal-golang-back-b154d239f542.herokuapp.com/user/get-courses';
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
            isPurchased = (data['course'] as List)
                .any((course) => course['id'] == widget.courseId);
          });
        } else {
          // Handle error
        }
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> buyCourse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      // Handle the case where the token is not available
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User token not found')),
      );
      return;
    }

    final url = 'https://kamal-golang-back-b154d239f542.herokuapp.com/user/buy-course/${widget.courseId}';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode <299) {
        // Handle successful purchase
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course purchased successfully')),
        );

        setState(() {
          isPurchased = true;
        });
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to purchase course')),
        );
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
    }
  }

  void startCourse() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseContentPage(courseId: widget.courseId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isLoading
          ? null
          : SingleChildScrollView(
            child: Container(
                    height: 50,
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(isPurchased ? Colors.green:Color(0xFF0085A1)),
            ),
            onPressed: isPurchased ? startCourse : buyCourse,
            child: Center(
              child: Text(
                isPurchased ? 'Курсты бастау' : 'Курсты сатып алу',
                style: const TextStyle(color: Colors.white),
              ),
            ),
                    ),
                  ),
          ),
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(child: child, scale: animation);
                },
                child: Icon(
                  Icons.favorite,
                  key: ValueKey<bool>(_isTapped),
                  color: _isTapped ? Colors.red : Colors.black,
                  size: 30.0,
                ),
              ),
              onPressed: () {
                setState(() {
                  _isTapped = !_isTapped;
                });
              },
            ),
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFF0085A1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 4,
                      blurRadius: 6,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.28,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: courseImage.isNotEmpty
                      ? SvgPicture.asset(
                    courseImage.substring(1),
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                    'assets/images/placeholder.png', // Path to your placeholder image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                  vertical: MediaQuery.of(context).size.height * 0.015),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        color: Color(0xFF0085A1),
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xFF0085A1),
                        borderRadius: BorderRadius.circular(16)),
                    child: const FittedBox(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 32,
                            ),
                            Text(
                              '4.5',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
