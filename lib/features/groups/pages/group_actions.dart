import 'package:flutter/material.dart';

import '../models/models_index.dart';

class GroupActions extends StatefulWidget {
  final Group group;
  const GroupActions({super.key, required this.group});

  @override
  State<GroupActions> createState() => _GroupActionsState();
}

class _GroupActionsState extends State<GroupActions>
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
    var dt = DateTime.now();
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sept",
      "Oct",
      "Nov",
      "Dec",
    ];
    var sdt = group.sdt;
    var sMonth = sdt.month;
    var sYear = sdt.year;
    tabs = [];
    var currentDtStr = "${months[dt.month - 1]}-${dt.year}";
    for (int i = sMonth; i < sMonth + 12; i++) {
      var month = ((i - 1) % 11);
      var tabStr = "${months[month]}-$sYear";
      tabMonths.add(tabStr);
      tabs.add(Tab(
        text: tabStr,
      ));
      tabContent.add(buildTabContent(tabStr));
      if (i % 11 == 0) {
        sYear++;
      }
      if (dt.year >= sYear && month >= dt.month) {
        break;
      }
    }
    var initialIndex = tabMonths.indexOf(currentDtStr);
    initialIndex = initialIndex >= 0 ? initialIndex : 0;
    tabController = TabController(
        length: tabs.length, vsync: this, initialIndex: initialIndex);
  }

  Widget buildTabContent(String month) {
    return Center(
      child: Text(month),
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
