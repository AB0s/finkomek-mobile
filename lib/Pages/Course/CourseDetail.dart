import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'ChechOutPage.dart';
import 'CourseContentPage.dart';

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
  double rating = 4.5; // Assuming a static rating, you can adjust it accordingly
  String courseType = 'Бейне-материал'; // Assuming a static course type

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

  void startCourse() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseContentPage(courseId: widget.courseId),
      ),
    );
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

      if (response.statusCode < 299) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Курс жайлы'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: courseImage.isNotEmpty
                    ? Image.asset(
                  courseImage.substring(1, courseImage.length - 3) + "png",
                  fit: BoxFit.cover,
                )
                    : Image.asset(
                  'assets/images/placeholder.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              'бағасы ${cost} тг',
              style: const TextStyle(
                  color: Color(0xFF018733),
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(
                  Icons.star_outlined,
                  color: Colors.yellow,
                  size: 26,
                ),
                const SizedBox(width: 8),
                Text(
                  rating.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                    isPurchased ? Colors.green : Color(0xFF0085A1)),
              ),
              onPressed: () {
                if (isPurchased) {
                  startCourse();
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutPage(
                        courseId: widget.courseId,
                        courseName: title,
                        coursePrice: cost.toDouble(),
                        courseRating: rating,
                        courseType: courseType,
                        onCoursePurchased: () {
                          setState(() {
                            isPurchased = true;
                          });
                        },
                      ),
                    ),
                  );
                }
              },
              child: Center(
                child: Text(
                  isPurchased ? 'Курсты бастау' : 'Курсты сатып алу',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
