import 'package:bachat_gat/common/utils.dart';
import 'package:flutter/material.dart';

import '../../models/models_index.dart';
import '../member/member_details_list.dart';

class GroupDetailsScreen extends StatefulWidget {
  final Group group;
  const GroupDetailsScreen({super.key, required this.group});

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen>
    with SingleTickerProviderStateMixin {
  late Group group;
  List<String> tabMonths = [];
  List<Tab> tabs = [];
  List<Widget> tabContent = [];
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    group = widget.group;
    buildMonths();
  }

  void buildMonths() {
    tabs = [];
    tabMonths = AppUtils.getMonthStringsFromStartToEndDt(group.sdt, group.edt);
    for (var tabStr in tabMonths) {
      tabs.add(Tab(
        text: tabStr,
      ));
      tabContent.add(buildTabContent(tabStr));
    }
    var dt = DateTime.now();
    var currentDtStr = AppUtils.getTrxPeriod(dt.month, dt.year);
    var initialIndex = tabMonths.indexOf(currentDtStr);
    initialIndex = initialIndex >= 0 ? initialIndex : 0;
    tabController = TabController(
      length: tabs.length,
      vsync: this,
      initialIndex: initialIndex,
    );
  }

  Widget buildTabContent(String month) {
    return MemberDetailsList(
      trxPeriod: month,
      group: group,
    );
  }

  @override
  Widget build(BuildContext context) {
    String title = "${group.name} ";
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              title,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text(
              "${tabMonths.first} - ${tabMonths.last}",
            ),
          ),
        ],
        bottom: TabBar(
          tabs: tabs,
          isScrollable: true,
          controller: tabController,
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: tabContent,
      ),
    );
  }
}
