import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'MeetingTimeSelector.dart';
import 'CheckoutPage.dart';

class ExpertDetailPage extends StatefulWidget {
  final int expertId;

  const ExpertDetailPage({Key? key, required this.expertId}) : super(key: key);

  @override
  _ExpertDetailPageState createState() => _ExpertDetailPageState();
}

class _ExpertDetailPageState extends State<ExpertDetailPage> {
  bool isLoading = true;
  bool isMeetingLoading = true;
  Map<String, dynamic> expert = {};
  List<dynamic> availableMeetings = [];
  List<String> availableDates = [];
  String selectedDate = '';
  int selectedTimeId = -1;

  @override
  void initState() {
    super.initState();
    fetchExpertDetails();
    fetchAvailableMeetings();
  }

  Future<void> fetchExpertDetails() async {
    final url =
        'https://kamal-golang-back-b154d239f542.herokuapp.com/expert/${widget.expertId}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        if (data['status'] == 'success') {
          if (mounted) {
            setState(() {
              expert = data['expert'];
              isLoading = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> fetchAvailableMeetings() async {
    final url =
        'https://kamal-golang-back-b154d239f542.herokuapp.com/expert/meets/${widget.expertId}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        if (data['status'] == 'success') {
          if (mounted) {
            setState(() {
              availableMeetings = data['expert'];
              availableDates = availableMeetings
                  .map<String>(
                      (meeting) => meeting['timeStart'].substring(0, 10))
                  .toSet()
                  .toList();
              isMeetingLoading = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              isMeetingLoading = false;
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            isMeetingLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isMeetingLoading = false;
        });
      }
    }
  }

  void onDateSelected(String date) {
    setState(() {
      selectedDate = date;
    });
  }

  void onTimeSelected(int timeId) {
    setState(() {
      selectedTimeId = timeId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Эксперттің мәліметтері'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: expert['imageLink'] != null
                          ? Image.network(
                              expert['imageLink'],
                              height: MediaQuery.of(context).size.height * 0.3,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/placeholder.png',
                              height: MediaQuery.of(context).size.height * 0.3,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${expert['firstName']} ${expert['lastName']}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    expert['email'],
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${expert['cost']} тг/сағ',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    expert['description'],
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  MeetingTimeSelector(
                    availableDates: availableDates,
                    availableMeetings: availableMeetings,
                    onDateSelected: onDateSelected,
                    onTimeSelected: onTimeSelected,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 20,right: 20),
        child: ElevatedButton(
          onPressed: selectedDate.isNotEmpty && selectedTimeId != -1
              ? () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutPage(
                        expert: expert,
                        meetingTimeId: selectedTimeId,
                        roomId: availableMeetings.firstWhere((meeting) =>
                            meeting['Id'] == selectedTimeId)['roomId'],
                        meetingTime: availableMeetings.firstWhere(
                            (meeting) => meeting['Id'] == selectedTimeId),
                        onBookingSuccess: fetchAvailableMeetings,
                      ),
                    ),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF0E7C9F),
          ),
          child: const Text('Жалғастыру'),
        ),
      ),
    );
  }
}
