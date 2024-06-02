import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SmallCourseCard extends StatelessWidget {
  const SmallCourseCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(8),
      ),
      width: MediaQuery.of(context).size.width * 0.55,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Center(child: SvgPicture.asset('assets/1Course.svg',)),
            const Text(
              'Балаларға арнағалан қаржылық сауаттылық курсы',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
