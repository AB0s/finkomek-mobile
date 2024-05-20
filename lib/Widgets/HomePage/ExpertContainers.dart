import 'package:flutter/material.dart';

class ExpertContainers extends StatefulWidget {
  const ExpertContainers({Key? key}) : super(key: key);

  @override
  State<ExpertContainers> createState() => _ExpertContainersState();
}

class _ExpertContainersState extends State<ExpertContainers> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.57),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 25, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('CHECK OUT OUR EXPERTS'),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            color: Colors.grey),
                        width: 150,
                        height: 80,
                        child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            child: Image.asset(
                              'assets/1Expert.png',
                              fit: BoxFit.cover,
                            )),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                topLeft: Radius.circular(20)),
                            color: Colors.grey),
                        width: 205,
                        height: 80,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              topLeft: Radius.circular(20)),
                          child: Image.asset(
                            'assets/3Expert.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(0),
                              topLeft: Radius.circular(20)),
                          color: Colors.grey,
                        ),
                        width: 215,
                        height: 80,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(0),
                              topLeft: Radius.circular(20)),
                          child: Image.asset(
                            'assets/4Expert.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                topLeft: Radius.circular(20)),
                            color: Colors.grey),
                        width: 140,
                        height: 80,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                          child: Image.asset(
                            'assets/2Expert.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
