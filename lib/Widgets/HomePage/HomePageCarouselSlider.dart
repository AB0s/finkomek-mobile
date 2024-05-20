import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';


class HomePageCarouselSlider extends StatefulWidget {
  const HomePageCarouselSlider({Key? key}) : super(key: key);

  @override
  State<HomePageCarouselSlider> createState() => _HomePageCarouselSliderState();
}

class _HomePageCarouselSliderState extends State<HomePageCarouselSlider> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.35),
      child: CarouselSlider(
        items: [
          SvgPicture.asset(
            'assets/Group 362.svg',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          SvgPicture.asset(
            'assets/SecondPage.svg',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SvgPicture.asset(
            'assets/ThirdPage.svg',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          SvgPicture.asset(
            'assets/FourthPage.svg',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ],
        options: CarouselOptions(
          height: 200,
          viewportFraction: 1,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration:
          const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          enlargeFactor: 0.3,
          scrollDirection:
          Axis.horizontal, // Enable infinite scroll
        ),
      ),
    );
  }
}
