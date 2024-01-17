import 'package:flutter/material.dart';

import '../models/models_index.dart';

class GroupActions extends StatefulWidget {
  final Group group;
  const GroupActions({super.key, required this.group});

  @override
  State<GroupActions> createState() => _GroupActionsState();
}

class _GroupActionsState extends State<GroupActions> {
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
  int currentMonth = 0;
  int currentYear = 0;

  @override
  void initState() {
    super.initState();
    var dt = DateTime.now();
    currentMonth = dt.month;
    currentYear = dt.year;
  }

  void buildMonths() {}

  @override
  Widget build(BuildContext context) {
    final _kTabs = months.map((e) => Tab(text: "$e-$currentYear")).toList();
    final _kTabPages = months
        .map((e) =>
            Center(child: Icon(Icons.cloud, size: 64.0, color: Colors.teal)))
        .toList();
    return DefaultTabController(
      length: _kTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Group"),
          bottom: TabBar(tabs: _kTabs, isScrollable: true),
        ),
        body: TabBarView(
          children: _kTabPages,
        ),
      ),
    );
  }
}
