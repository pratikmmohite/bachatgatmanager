import 'package:flutter/material.dart';

import '../../dao/dao_index.dart';
import '../../models/models_index.dart';
import '../pdf//pdf_api.dart';

class MonthlyReport extends StatefulWidget {
  const MonthlyReport(this.group, this.members, this.intitalName, {Key? key})
      : super(key: key);
  final Group group;
  final List<GroupMember> members;
  final String intitalName;

  @override
  State<MonthlyReport> createState() => _MonthlyReportState();
}

class _MonthlyReportState extends State<MonthlyReport> {
  late Group _group;
  late List<GroupMember> _members;
  late String selectedMemberId;
  late List<MemberTransactionDetails> memberData;
  late String selectedMemberName;

  @override
  void initState() {
    super.initState();
    _group = widget.group;
    _members = widget.members;
    selectedMemberId = _members.isEmpty ? "" : _members[0].id;
    selectedMemberName = _members.isEmpty ? " " : _members[0].name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Monthly Report"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Dropdown for Member List
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(05),
              ),
              child: DropdownButton<String>(
                menuMaxHeight: 300,
                hint: const Text("Select Member"),
                icon: const Icon(Icons.group),
                iconSize: 20,
                isExpanded: true,
                value: selectedMemberId,
                onChanged: (newValue) {
                  setState(() {
                    selectedMemberId = newValue!;
                    selectedMemberName = _members
                        .firstWhere((member) => member.id == newValue)
                        .name;
                  });
                },
                items: _members.map((valueItem) {
                  return DropdownMenuItem<String>(
                    value: valueItem.id,
                    child: Text(
                      valueItem.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 15),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Download Button
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.download),
                    onPressed: () async {
                      final dao = GroupsDao();
                      final data = await dao.getMemberDetailsByMemberId(
                          selectedMemberId, _group.id);
                      if (data != null) {
                        await PdfApi.generateTable(
                            data, selectedMemberName, _group.name.toString());
                      } else {
                        // Handle case when no data is returned
                        // e.g., show a snackbar indicating no data found
                      }
                    },
                    label: const Text('Download'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// class MonthlyReport extends StatefulWidget {
//   const MonthlyReport(this.group, this.members, this.intitalName, {super.key});
//   final Group group;
//   final List<GroupMember> members;
//   final String intitalName;
//   @override
//   State<MonthlyReport> createState() => _MonthlyReportState();
// }

// class _MonthlyReportState extends State<MonthlyReport> {
//   bool isLoading = false;
//   late List<GroupMember> _members;
//   late GroupsDao groupDao;
//   late Group _group;
//   late List<MemberTransactionDetails> memberData;
//   final TextEditingController memberController = TextEditingController();
//   final TextEditingController monthController = TextEditingController();
//
//   late String selectedMemberId;
//   String monthValue = "January";
//   final List<String> monthList = [
//     'January',
//     'February',
//     'March',
//     'April',
//     'May',
//     'June',
//     'July',
//     'August',
//     'September',
//     'October',
//     'November',
//     'December',
//   ]; // Add your months
//   // void getMemberReportData() {
//   //   var dataMember =
//   //       groupDao.getMemberDetailsByMemberId(selectedMemberId, _group.id);
//   //   memberData = dataMember as List<MemberTransactionDetails>;
//   //   // print(dataMember);
//   // }
//
//   @override
//   void initState() {
//     super.initState();
//     _group = widget.group;
//     groupDao = GroupsDao();
//     _members = widget.members;
//     selectedMemberId = _members.isEmpty ? "" : _members[0].id;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Monthly Report"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Dropdown for Member List
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: Colors.black,
//                   width: 0.5,
//                 ),
//                 borderRadius: BorderRadius.circular(05),
//               ),
//               child: DropdownButton<String>(
//                 menuMaxHeight: 300,
//                 hint: const Text("Select Member"),
//                 icon: const Icon(Icons.group),
//                 iconSize: 20,
//                 isExpanded: true,
//                 value: selectedMemberId,
//                 onChanged: (newValue) {
//                   setState(() {
//                     selectedMemberId = newValue!;
//                   });
//                 },
//                 items: _members.map((valueItem) {
//                   return DropdownMenuItem<String>(
//                     value: valueItem.id,
//                     child: Text(
//                       valueItem.name,
//                       style: const TextStyle(
//                           fontWeight: FontWeight.normal, fontSize: 15),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//
//             // DropdownButton<String>(
//             //   menuMaxHeight: 200,
//             //   padding: const EdgeInsets.only(
//             //       top: 50, bottom: 50, left: 50, right: 50),
//             //   hint: const Text("Select Month"),
//             //   icon: const Icon(Icons.calendar_month),
//             //   iconSize: 20,
//             //   isExpanded: true,
//             //   value: monthValue,
//             //   onChanged: (newValue) {
//             //     setState(() {
//             //       monthValue = newValue!;
//             //     });
//             //   },
//             //   items: monthList.map((month) {
//             //     return DropdownMenuItem<String>(
//             //       value: month,
//             //       child: Text(
//             //         month,
//             //         style: const TextStyle(
//             //             fontWeight: FontWeight.normal, fontSize: 15),
//             //       ),
//             //     );
//             //   }).toList(),
//             // ),
//             // Download Button
//             const SizedBox(height: 15),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     icon: const Icon(Icons.download),
//                     onPressed: () {
//                       // getMemberReportData();
//                       PdfApi.generateTable();
//                     },
//                     label: const Text('Download'),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:bachat_gat/features/groups/pages/pdf/pdf_api.dart';
// import 'package:flutter/material.dart';
//
// import '../../dao/dao_index.dart';
// import '../../models/models_index.dart';
//
// class MonthlyReport extends StatefulWidget {
//   MonthlyReport(this.group, this.members, {super.key});
//   final Group group;
//   List<GroupMember> members;
//   @override
//   State<MonthlyReport> createState() => _MonthlyReportState();
// }
//
// class _MonthlyReportState extends State<MonthlyReport> {
//   bool isLoading = false;
//   List<GroupMember> _members = [];
//   late GroupsDao groupDao;
//   late Group _group;
//
//   final TextEditingController memberController = TextEditingController();
//   final TextEditingController monthController = TextEditingController();
//
//   late String valueChoose;
//   String monthValue = "January";
//   List listItem = ['Item1', 'Item2', 'Item3', 'Item4', 'Item5'];
//   final List monthList = [
//     'January',
//     'February',
//     'March',
//     'April',
//     'May',
//     'June',
//     'July',
//     'August',
//     'September',
//     'October',
//     'November',
//     'December',
//   ]; // Add your months
//
//   @override
//   void initState() {
//     _group = widget.group;
//     groupDao = GroupsDao();
//     _members = widget.members;
//     valueChoose = _members[1].name;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Monthly Report"),
//       ),
//       body: Center(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(height: 10, width: 10),
//             // Dropdown for Member List
//             DropdownButton<String>(
//               menuMaxHeight: 200,
//               padding: const EdgeInsets.only(
//                   top: 50, bottom: 50, left: 50, right: 50),
//               hint: const Text("Select Member"),
//               icon: const Icon(Icons.group),
//               iconSize: 20,
//               isExpanded: true,
//               value: valueChoose,
//               onChanged: (newValue) {
//                 setState(() {
//                   valueChoose = newValue.toString();
//                 });
//               },
//               items: _members.map((valueItem) {
//                 return DropdownMenuItem<String>(
//                   value: valueItem.name!,
//                   child: Text(
//                     valueItem.name,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.normal, fontSize: 15),
//                   ),
//                 );
//               }).toList(),
//             ),
//
//             DropdownButton<String>(
//               menuMaxHeight: 200,
//               padding: const EdgeInsets.only(
//                   top: 50, bottom: 50, left: 50, right: 50),
//               hint: const Text("Select Month"),
//               icon: const Icon(Icons.calendar_month),
//               iconSize: 20,
//               isExpanded: true,
//               value: monthValue,
//               onChanged: (newValue) {
//                 setState(() {
//                   monthValue = newValue.toString();
//                 });
//               },
//               items: monthList.map((month) {
//                 return DropdownMenuItem<String>(
//                   value: month,
//                   child: Text(
//                     month,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.normal, fontSize: 15),
//                   ),
//                 );
//               }).toList(),
//             ),
//             // Download Button
//             ElevatedButton(
//               onPressed: () {
//                 PdfApi.generateTable();
//               },
//               child: const Text('Download'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
