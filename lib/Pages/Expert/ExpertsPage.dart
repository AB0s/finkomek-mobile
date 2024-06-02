import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:llf/Widgets/Expert/ExpertCard.dart';
import 'package:llf/Widgets/Expert/SmallExpertCard.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ExpertsPage extends StatefulWidget {
  const ExpertsPage({Key? key}) : super(key: key);

  @override
  State<ExpertsPage> createState() => _ExpertsPageState();
}

class _ExpertsPageState extends State<ExpertsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final int numberOfExpertsInGrid = 6;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                children: [
                  ExpertCard(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: RawScrollbar(
                      controller: _scrollController,
                      // Use the same ScrollController instance
                      thumbColor: const Color(0xFFAED7E0),
                      radius: const Radius.circular(20),
                      thumbVisibility: true,
                      thickness: 10,
                      child: ListView.separated(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 6,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return const Padding(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: Center(child: SmallExpertCard()),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            width: 10,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Text(
                'Баскада Эксперттерды карау',
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.36 *
                    (numberOfExpertsInGrid / 2),
                child: GridView.custom(
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverStairedGridDelegate(
                        crossAxisSpacing: 15,
                        tileBottomSpace: 15,
                        mainAxisSpacing: 10,
                        pattern: [
                          StairedGridTile(0.5, 0.7),
                          StairedGridTile(0.5, 0.7),
                        ]),
                    childrenDelegate: SliverChildBuilderDelegate(
                        (context, index) => SmallExpertCard(),
                        childCount: numberOfExpertsInGrid)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
