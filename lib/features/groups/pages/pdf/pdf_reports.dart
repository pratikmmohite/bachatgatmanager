import 'package:bachat_gat/common/common_index.dart';
import 'package:bachat_gat/features/groups/pages/pdf/montly_report.dart';
import 'package:flutter/material.dart';

import '../../dao/dao_index.dart';
import '../../models/models_index.dart';

class PdfReports extends StatefulWidget {
  const PdfReports(this.group, {super.key});
  final Group group;

  @override
  State<PdfReports> createState() => _PdfReportsState();
}

class _PdfReportsState extends State<PdfReports> {
  bool isLoading = false;
  List<GroupMember> members = [];
  late GroupsDao groupDao;
  late Group _group;
  Future<void> getMembers() async {
    members = [];
    var filter = MemberFilter(_group.id);
    setState(() {
      isLoading = true;
    });
    try {
      members = await groupDao.getMembers(filter);
    } catch (e) {
      AppUtils.toast(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    _group = widget.group;
    groupDao = GroupsDao();
    getMembers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Report"),
        ),
        body: Column(
          children: [
            Card(
                child: ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MonthlyReport(
                          widget.group, members, members[0].name)),
                );
              },
              title: const Text("Monthly Reports"),
            )),
            const Card(
                child: ListTile(
              leading: Icon(Icons.picture_as_pdf),
              title: Text("Yearly Report"),
            ))
          ],
        ));
  }
}
