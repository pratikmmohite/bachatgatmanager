import 'package:bachat_gat/common/common_index.dart';
import 'package:bachat_gat/features/groups/pages/pdf/member_report.dart';
import 'package:bachat_gat/features/groups/pages/pdf/yearly_report.dart';
import 'package:flutter/material.dart';

import '../../dao/dao_index.dart';
import '../../models/models_index.dart';
import 'monthly_report.dart';

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
                if (members.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Add Members for displaying list",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MemberReport(
                        widget.group,
                        members,
                        members[0].name,
                      ),
                    ),
                  );
                }
              },
              title: const Text("Member Reports"),
            )),
            Card(
              child: ListTile(
                leading: const Icon(Icons.group),
                title: const Text("Monthly Report (मासिक अहवाल"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MonthlyReport(widget.group)));
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.picture_as_pdf),
                title: const Text("Yearly Report"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => YearlyReport(widget.group),
                    ),
                  );
                },
              ),
            )
          ],
        ));
  }
}
