import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Pages/Chat/ChatPage.dart';

class ConsultationWidget extends StatefulWidget {
  final bool showAll;

  const ConsultationWidget({Key? key, this.showAll = false}) : super(key: key);

  @override
  _ConsultationWidgetState createState() => _ConsultationWidgetState();
}

class _ConsultationWidgetState extends State<ConsultationWidget> {
  bool isLoading = true;
  List<dynamic> consultations = [];
  String userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
    fetchConsultations();
  }

  Future<void> _loadUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('fname') ?? '';
    });
  }

  Future<void> fetchConsultations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final url = 'https://kamal-golang-back-b154d239f542.herokuapp.com/user/get-meets';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          consultations = widget.showAll ? data : data.take(3).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>> fetchExpertDetails(String expertId) async {
    final url = 'https://kamal-golang-back-b154d239f542.herokuapp.com/expert/$expertId';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return data['expert'];
      } else {
        throw Exception('Failed to load expert details');
      }
    } catch (e) {
      throw Exception('Failed to load expert details');
    }
  }

  String formatDate(String dateTime) {
    DateTime date = DateTime.parse(dateTime);
    return DateFormat('d MMMM', 'ru').format(date);
  }

  String formatTime(String startDateTime, String endDateTime) {
    DateTime start = DateTime.parse(startDateTime);
    DateTime end = DateTime.parse(endDateTime);
    return '${start.hour}:${start.minute.toString().padLeft(2, '0')} - ${end.hour}:${end.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    double consultationWidgetWidth = MediaQuery.of(context).size.width * 0.9;

    return isLoading
        ? Center(child: CircularProgressIndicator())
        : consultations.isEmpty
        ? Center(child: Text('Әзірге кездесулер жоқ'))
        : ListView.separated(
      primary: false,
      shrinkWrap: true,
      itemCount: consultations.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        var consultation = consultations[index];
        String roomId = consultation['roomId'];
        String expertId = consultation['expertId'].toString();

        return FutureBuilder<Map<String, dynamic>>(
          future: fetchExpertDetails(expertId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading expert details'));
            } else {
              var expert = snapshot.data!;
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: consultationWidgetWidth * 0.6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${expert['firstName']} ${expert['lastName']}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text('Күнделікті финанстық консултация'),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.calendar_month),
                                  SizedBox(width: 5),
                                  Text(formatDate(consultation['timeStart'])),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.watch_later_outlined),
                                  SizedBox(width: 5),
                                  Text(formatTime(consultation['timeStart'], consultation['timeEnd'])),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: consultationWidgetWidth * 0.3,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                    roomId: roomId,
                                    userName: userName,
                                    expertName: '${expert['firstName']} ${expert['lastName']}',
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              foregroundColor: const Color(0xFF0C6683),
                              backgroundColor: const Color(0xFFE7F4F8),
                            ),
                            child: const Text('Чат'),
                          ),
                        ),
                        SizedBox(
                          width: consultationWidgetWidth * 0.3,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              foregroundColor: const Color(0xFFAB2204),
                              backgroundColor: const Color(0xFFFFE1DA),
                            ),
                            child: const Text('Бас тарту'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 20,
        );
      },
    );
  }
}
