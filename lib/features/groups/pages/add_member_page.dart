import 'package:bachat_gat/features/groups/dao/groups_dao.dart';
import 'package:bachat_gat/features/groups/models/group_members.dart';
import 'package:flutter/material.dart';

import '../models/group.dart';

class MemberAddPage extends StatefulWidget {
  final Group group;
  final GroupMember? groupMember;
  const MemberAddPage(this.group, {super.key, this.groupMember});

  @override
  State<MemberAddPage> createState() => _MemberAddPageState();
}

class _MemberAddPageState extends State<MemberAddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late GroupMember _groupMember;
  late Group _group;
  late GroupsDao dao;
  bool isAdd = true;

  @override
  void initState() {
    super.initState();
    _group = widget.group;
    if (widget.groupMember == null) {
      isAdd = true;
      _groupMember = GroupMember.withDefault(_group);
    } else {
      isAdd = false;
      _groupMember = widget.groupMember!;
    }
    dao = GroupsDao();
  }

  Widget buildTextField(
      {required String label,
      required String field,
      required String value,
      int? maxLines,
      TextInputType? keyboardType,
      ValueChanged<String>? onChange}) {
    return TextFormField(
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: onChange,
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        hintText: "Enter $label",
        filled: true,
      ),
    );
  }

  Widget buildSpace({double width = 0, double height = 10}) {
    return SizedBox(
      width: width,
      height: height,
    );
  }

  Widget buildDateRangeField(
      {required String label,
      required String field,
      required DateTime sdt,
      required DateTime edt,
      required ValueChanged<DateTimeRange> onChange}) {
    var dt = DateTimeRange(start: sdt, end: edt);
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        hintText: "Enter $label",
        filled: true,
      ),
      initialValue: dt.toString(),
      onTap: () async {
        DateTimeRange? selectedDate = await showDateRangePicker(
            context: context,
            initialDateRange: dt,
            firstDate: DateTime(2000),
            lastDate: DateTime(2099));
        if (selectedDate != null) {
          onChange(selectedDate);
        }
      },
    );
  }

  Widget buildDateField(
      {required String label,
      required String field,
      required DateTime value,
      required ValueChanged<DateTime> onChange}) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        hintText: value.toString(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        filled: true,
      ),
      readOnly: true,
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
            context: context,
            initialDate: value,
            firstDate: DateTime(2000),
            lastDate: DateTime(2099));
        if (selectedDate != null) {
          onChange(selectedDate);
        }
      },
    );
  }

  void closePage() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Saving Group")),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField(
                  label: "Member Name",
                  field: "name",
                  value: _groupMember.name,
                  onChange: (value) {
                    _groupMember.name = value;
                  }),
              buildTextField(
                label: "Mobile No",
                field: "mobileNo",
                value: _groupMember.mobileNo ?? "",
                onChange: (value) {
                  _groupMember.mobileNo = value;
                },
                keyboardType: TextInputType.phone,
              ),
              Table(
                children: [
                  TableRow(
                    children: [
                      buildTextField(
                        label: "Aadhar No",
                        field: "aadharNo",
                        value: _groupMember.aadharNo ?? "",
                        onChange: (value) {
                          _groupMember.aadharNo = value;
                        },
                        keyboardType: TextInputType.number,
                      ),
                      buildTextField(
                        label: "Pan No",
                        field: "panNo",
                        value: _groupMember.panNo ?? "",
                        onChange: (value) {
                          _groupMember.panNo = value;
                        },
                      ),
                    ],
                  ),
                ],
              ),
              buildDateField(
                label: "Joining Date",
                field: "joiningDate",
                value: _groupMember.joiningDate,
                onChange: (value) {
                  setState(() {
                    _groupMember.joiningDate = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (_formKey.currentState?.validate() ?? false) {
            int updatedRows = 0;
            if (isAdd) {
              updatedRows = await dao.addGroupMember(_groupMember);
            } else {
              updatedRows = await dao.updateGroupMember(_groupMember);
            }
            if (updatedRows > 0) {
              closePage();
            }
          }
        },
        label: const Text("Save"),
        icon: const Icon(Icons.save),
      ),
    );
  }
}
