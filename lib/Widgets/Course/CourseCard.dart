import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Pages/Course/CourseDetail.dart';

class CourseCard extends StatefulWidget {
  final String id;
  final String title;
  final String description;
  final String courseImage;

  const CourseCard({
    Key? key,
    required this.id,
    required this.title,
    required this.description,
    required this.courseImage,
  }) : super(key: key);

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              widget.courseImage.substring(1, widget.courseImage.length - 3) +
                  "png",
              height: 150,
              width: double.infinity,
            ),
            const SizedBox(height: 15),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CourseDetailPage(courseId: widget.id),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF0E7C9F),
                ),
                child: const Text('Курсқа өту'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
