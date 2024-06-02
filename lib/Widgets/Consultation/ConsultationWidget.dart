import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ConsultaionWidget extends StatefulWidget {
  const ConsultaionWidget({Key? key}) : super(key: key);

  @override
  State<ConsultaionWidget> createState() => _ConsultaionWidgetState();
}

class _ConsultaionWidgetState extends State<ConsultaionWidget> {
  @override
  Widget build(BuildContext context) {
    double _consultationWidgetWidth = MediaQuery.of(context).size.width*0.9;
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
            width: _consultationWidgetWidth*0.6,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Байболат Ақниет',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text('Күнделікті финанстық консултация'),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_month),
                        SizedBox(
                          width: 5,
                        ),
                        Text('8 Мамыр')
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.watch_later_outlined),
                        SizedBox(
                          width: 5,
                        ),
                        Text('15:00 - 17:00')
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(
                width: _consultationWidgetWidth*0.3,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),

                    foregroundColor: const Color(0xFF0C6683),
                    backgroundColor: const Color(0xFFE7F4F8),
                  ),
                  child: const Text('Қосылу'),
                ),
              ),
              SizedBox(
                width: _consultationWidgetWidth*0.3,
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
}
