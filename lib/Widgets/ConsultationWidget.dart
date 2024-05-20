import 'package:flutter/material.dart';

class ConsultaionWidget extends StatefulWidget {
  const ConsultaionWidget({Key? key}) : super(key: key);

  @override
  State<ConsultaionWidget> createState() => _ConsultaionWidgetState();
}

class _ConsultaionWidgetState extends State<ConsultaionWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28), topRight: Radius.circular(28)),
            color: Color(0xFF0085A1)),
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 10,left: 10,top: 20),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.3),
                        child: const Text(
                          'Күнделікті финанстық консултация',
                          style: TextStyle(
                              color: Color(0xFF00343F),
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.calendar_month),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text("Today's date"),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                          ),
                          const Icon(Icons.watch_later_outlined),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text('15:00-17:00'),
                        ],
                      ),
                      const Divider(
                        color: Color(0xFF2070B9),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFFFAA05),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    '4.5',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),
                          const Text(
                            'Айгүл Сәрсенбаева',
                            style: TextStyle(
                                color: Color(0xFF00343F),
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.email_outlined),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.025,
                          ),
                          Text('Aigul@gmail.com')
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.04,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: const Color(0xFF00343F),
                        ),
                        child: const Center(
                          child: Text(
                            'Кездесуді растау',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
