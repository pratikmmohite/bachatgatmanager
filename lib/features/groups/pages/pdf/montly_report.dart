import 'package:flutter/material.dart';

import '../../dao/dao_index.dart';
import '../../models/models_index.dart';
import '../pdf/pdf_api.dart';

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
  late DateTime _startDate = DateTime.now();
  late DateTime _endDate = DateTime.now();

  String _formattDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}";
  }

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
            const SizedBox(height: 15),
            // Date Pickers for Start and End Dates
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Start Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
                        label: Text(_formattDate(_startDate)),
                        icon: Icon(Icons.calendar_today),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate:
                                DateTime(_startDate.year, _startDate.month, 1),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null && picked != _startDate) {
                            setState(() {
                              _startDate = picked;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'End Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _endDate,
                            firstDate:
                                DateTime(_startDate.year, _startDate.month + 1),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null && picked != _endDate) {
                            setState(() {
                              _endDate = picked;
                            });
                          }
                        },
                        label: Text(_formattDate(_endDate)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // Download Button
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.download),
                    onPressed: () async {
                      final dao = GroupsDao();
                      final data = await dao.getMemberDetailsByMemberId(
                          selectedMemberId,
                          _group.id,
                          _formattDate(_startDate),
                          _formattDate(_endDate));
                      if (data.isNotEmpty) {
                        await PdfApi.generateTable(
                            data, selectedMemberName, _group.name.toString());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "There are no transaction between this period for the member please change the time period",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
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

// import 'package:flutter/material.dart';
//
// import '../../dao/dao_index.dart';
// import '../../models/models_index.dart';
// import '../pdf//pdf_api.dart';
//
// class MonthlyReport extends StatefulWidget {
//   const MonthlyReport(this.group, this.members, this.intitalName, {Key? key})
//       : super(key: key);
//   final Group group;
//   final List<GroupMember> members;
//   final String intitalName;
//
//   @override
//   State<MonthlyReport> createState() => _MonthlyReportState();
// }
//
// class _MonthlyReportState extends State<MonthlyReport> {
//   late Group _group;
//   late List<GroupMember> _members;
//   late String selectedMemberId;
//   late List<MemberTransactionDetails> memberData;
//   late String selectedMemberName;
//   late DateTime? _startDate;
//   late DateTime? _endDate;
//
//   @override
//   void initState() {
//     super.initState();
//     _group = widget.group;
//     _members = widget.members;
//     selectedMemberId = _members.isEmpty ? "" : _members[0].id;
//     selectedMemberName = _members.isEmpty ? " " : _members[0].name;
//     // _startDate = DateTime.now();
//     // _endDate = DateTime.now();
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
//                     selectedMemberName = _members
//                         .firstWhere((member) => member.id == newValue)
//                         .name;
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
//             const SizedBox(height: 15),
//
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     icon: const Icon(Icons.download),
//                     onPressed: () async {
//                       final dao = GroupsDao();
//                       final data = await dao.getMemberDetailsByMemberId(
//                           selectedMemberId, _group.id);
//                       if (data != null) {
//                         await PdfApi.generateTable(
//                             data, selectedMemberName, _group.name.toString());
//                       } else {
//                         // Handle case when no data is returned
//                         // e.g., show a snackbar indicating no data found
//                       }
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
