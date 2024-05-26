import 'package:flutter/material.dart';

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
    return Card(
      color: Color(colorCode),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handling network image with error handling
            courseImage.isNotEmpty
                ? Image.network(
              courseImage,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 100,
                  color: Colors.grey,
                  child: Center(child: Icon(Icons.error)),
                );
              },
            )
                : Container(
              height: 100,
              color: Colors.grey,
              child: Center(child: Icon(Icons.image)),
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
