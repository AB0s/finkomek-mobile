import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'ExpertDetail.page.dart';

class ExpertsPage extends StatefulWidget {
  const ExpertsPage({Key? key}) : super(key: key);

  @override
  _ExpertsPageState createState() => _ExpertsPageState();
}

class _ExpertsPageState extends State<ExpertsPage> {
  bool isLoading = true;
  List<dynamic> experts = [];

  @override
  void initState() {
    super.initState();
    fetchExperts();
  }

  @override
  void dispose() {
    // Add any additional disposal logic here
    super.dispose();
  }

  Future<void> fetchExperts() async {
    final url = 'https://kamal-golang-back-b154d239f542.herokuapp.com/expert/getAllExperts';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        if (data['status'] == 'success') {
          if (!mounted) return; // Check if the widget is still mounted
          setState(() {
            experts = data['experts'];
            isLoading = false;
          });
        } else {
          if (!mounted) return; // Check if the widget is still mounted
          setState(() {
            isLoading = false;
          });
        }
      } else {
        if (!mounted) return; // Check if the widget is still mounted
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Эксперттер'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Консультацияға жазылыңыз',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              primary: false,
              shrinkWrap: true,
              itemCount: experts.length,
              itemBuilder: (context, index) {
                var expert = experts[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExpertDetailPage(expertId: expert['Id']),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black.withOpacity(0.1)),
                    ),
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40.0),
                          child: Image.network(
                            expert['imageLink'],
                            height: 60.0,
                            width: 60.0,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error);
                            },
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${expert['firstName']} ${expert['lastName']}',
                                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                expert['description'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14.0),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${expert['cost']} тг/сағ',
                          style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 20);
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
