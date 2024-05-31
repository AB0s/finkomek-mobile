import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String description;
  final int colorCode;
  final String courseImage;

  const CourseCard({
    Key? key,
    required this.title,
    required this.description,
    required this.colorCode,
    required this.courseImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(courseImage.substring(1));
    return Card(
      color: Color(colorCode),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              courseImage.substring(1),
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              description,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
