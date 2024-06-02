import 'package:flutter/material.dart';

import '../Consultation/ConsultationWidget.dart';
import '../Course/CoursesTabView.dart';

class UserAccountTabbar extends StatefulWidget {
  const UserAccountTabbar({Key? key}) : super(key: key);

  @override
  State<UserAccountTabbar> createState() => _UserAccountTabbarState();
}

class _UserAccountTabbarState extends State<UserAccountTabbar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Expanded(
        child: NestedScrollView(
          headerSliverBuilder:
              (BuildContext context, bool boxIsScrolled) {
            return [
              SliverAppBar(
                scrolledUnderElevation:0,
                pinned: true,
                toolbarHeight: 40,
                automaticallyImplyLeading: false,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: ClipRRect(
                    borderRadius:
                    const BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: Colors.white,
                          border: Border.all(color: Color(0xFF0085A1))),
                      child: const TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        indicator: BoxDecoration(
                          color: Color(0xFF0085A1),
                          borderRadius:
                          BorderRadius.all(Radius.circular(10)),
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: Color(0xFF0085A1),
                        tabs: [
                          Text(
                            'Жеке күнтізбе',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text('Курстар', style: TextStyle(fontSize: 12)),
                          Text('Мұрағат', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ];
          },
          body: const TabBarView(
            children: <Widget>[
              ConsultaionWidget(),
              CoursesTabView(),
              Text('2'),
            ],
          ),
        ),
      ),
    );
  }
}
