import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CoursesTabView extends StatefulWidget {
  const CoursesTabView({Key? key}) : super(key: key);

  @override
  State<CoursesTabView> createState() => _CoursesTabViewState();
}

class _CoursesTabViewState extends State<CoursesTabView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28), topRight: Radius.circular(28)),
          color: Color(0xFF0085A1),
        ),
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF00809B),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, left: 15),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(16)),
                            child: Image.asset(
                              'assets/CreditCard.png',
                              height: MediaQuery.of(context).size.height * 0.10,
                              width: MediaQuery.of(context).size.width * 0.2,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Финанстық Сауаттылық 101'),
                              const SizedBox(
                                height: 10,
                              ),
                              LinearProgressIndicator(
                                borderRadius: BorderRadius.circular(16),
                                minHeight:
                                    MediaQuery.of(context).size.height * 0.012,
                                value: 0.43,
                                backgroundColor: const Color(0xFF2A94F4),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Color(0xFF00343F)),
                              ),
                              const Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text('43%')),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height:
                                    MediaQuery.of(context).size.height * 0.035,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: const Color(0xFF0085A1),
                                ),
                                child: const Center(
                                    child: Text(
                                  'Өту',
                                  style: TextStyle(color: Colors.white),
                                )),
                              )
                            ],
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
