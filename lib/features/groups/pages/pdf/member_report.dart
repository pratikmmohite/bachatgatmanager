import 'package:bachat_gat/locals/app_local_delegate.dart';
import 'package:flutter/material.dart';

import '../../dao/dao_index.dart';
import '../../models/models_index.dart';
import '../pdf/pdf_api.dart';

class MemberReport extends StatefulWidget {
  const MemberReport(this.group, this.members, this.intitalName, {super.key});
  final Group group;
  final List<GroupMember> members;
  final String intitalName;

  @override
  State<MemberReport> createState() => _MemberReportState();
}

class _MemberReportState extends State<MemberReport> {
  late Group _group;
  late List<GroupMember> _members;
  late String selectedMemberId;
  late List<MemberTransactionDetails> memberData;
  late String selectedMemberName;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  DateTimeRange dtchnage =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  String _formattDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}";
  }

  String formatDt(DateTime dt) {
    return dt.toString().split(" ")[0];
  }

  late TextEditingController _textController = TextEditingController(
      text: "${formatDt(_startDate)} to ${formatDt(_endDate)}");

  @override
  void initState() {
    super.initState();
    _group = widget.group;
    _members = widget.members;
    selectedMemberId = _members.isEmpty ? "" : _members[0].id;
    selectedMemberName = _members.isEmpty ? " " : _members[0].name;
    _startDate = DateTime.now();
    _endDate = DateTime.now();

    _textController = TextEditingController(
        text: "${formatDt(_startDate)} to ${formatDt(_endDate)}");
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocal.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(local.lmReport),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Dropdown for Member List
              const Divider(color: Colors.black),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 0.5,
                  ),
                  color: Colors.blueGrey.shade50,
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
              Container(
                margin: const EdgeInsets.all(2),
                child: TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Select Date (YYYY-MM-DD) to (YYYY-MM-DD)",
                    hintText: "Enter ${local.tfStartDate}",
                    filled: true,
                  ),
                  controller: _textController,
                  onTap: () async {
                    var dt = DateTimeRange(start: _startDate, end: _endDate);
                    DateTimeRange? selectedRange = await showDateRangePicker(
                      context: context,
                      initialDateRange: dt,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2099),
                    );
                    if (selectedRange != null) {
                      setState(() {
                        _startDate = selectedRange.start;
                        _endDate = selectedRange.end;
                        _textController.text =
                            "${formatDt(selectedRange.start)} to ${formatDt(selectedRange.end)}";
                        dtchnage = selectedRange;
                      });
                    }
                  },
                ),
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
                        final remainingLoan = await dao.getRemainingLoan(
                            _group.id,
                            selectedMemberId,
                            _formattDate(_startDate));

                        if (data.isNotEmpty) {
                          var bytes = await PdfApi.generateTable(
                              data,
                              selectedMemberName,
                              _group.name.toString(),
                              remainingLoan,
                              context);
                          await PdfApi.saveAsPDF(selectedMemberName, bytes);
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
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.download),
                      onPressed: () async {
                        final dao = GroupsDao();
                        final List<MemberTransactionDetails> data =
                            await dao.getMemberDetailsByMemberId(
                                selectedMemberId,
                                _group.id,
                                _formattDate(_startDate),
                                _formattDate(_endDate));
                        final remainingLoan = await dao.getRemainingLoan(
                            _group.id,
                            selectedMemberId,
                            _formattDate(_startDate));

                        // print(remainingLoan);
                        //print(data);

                        if (data.isNotEmpty) {
                          var bytes = await PdfApi.generateTable(
                              data,
                              selectedMemberName,
                              _group.name.toString(),
                              remainingLoan,
                              context);
                          await PdfApi.previewPDF(bytes);
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
                      label: const Text('Preview'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
