import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:llf/Pages/Course/CourseDetail.dart';

class CourseCard extends StatefulWidget {
  final String title;
  final String description;
  final int colorCode;
  final String courseImage;

  CourseCard(
      {Key? key,
      required this.title,
      required this.description,
      required this.colorCode,
      required this.courseImage})
      : super(key: key);

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(widget.colorCode),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 15),
          child: Row(
            children: [
              SizedBox(
                width: 185,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                    Text(
                      widget.description,
                      style: const TextStyle(fontSize: 13, color: Colors.white),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(),
                child: SvgPicture.asset(
                  widget.courseImage,
                  width: 100,
                  height: 80,
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CourseDetailPage(
                      title: widget.title,
                      description: widget.description,
                      courseImage: widget.courseImage,
                    )));
      },
    );
  }
}
