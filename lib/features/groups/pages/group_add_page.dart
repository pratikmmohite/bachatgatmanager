import 'package:bachat_gat/features/groups/dao/groups_dao.dart';
import 'package:flutter/material.dart';

import '../models/group.dart';

class GroupAddPage extends StatefulWidget {
  final Group? group;
  const GroupAddPage({super.key, this.group});

  @override
  State<GroupAddPage> createState() => _GroupAddPageState();
}

class _GroupAddPageState extends State<GroupAddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Group group;
  late GroupsDao dao;
  bool isAdd = true;

  @override
  void initState() {
    super.initState();
    if (widget.group == null) {
      isAdd = true;
      group = Group.withDefault();
    } else {
      isAdd = false;
      group = widget.group!;
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
                  label: "Group Name",
                  field: "name",
                  value: group.name,
                  onChange: (value) {
                    group.name = value;
                  }),
              buildDateRangeField(
                label: "Start Date - End Date",
                field: "sdt_edt",
                sdt: group.sdt,
                edt: group.edt,
                onChange: (value) {
                  setState(() {
                    group.sdt = value.start;
                    group.edt = value.end;
                  });
                },
              ),
              buildTextField(
                label: "Address",
                field: "address",
                value: group.address ?? "",
                onChange: (value) {
                  group.address = value;
                },
                maxLines: 3,
                keyboardType: TextInputType.multiline,
              ),
              Table(
                children: [
                  TableRow(
                    children: [
                      buildTextField(
                        label: "Bank Name",
                        field: "bankName",
                        value: group.bankName ?? "",
                        onChange: (value) {
                          group.bankName = value;
                        },
                      ),
                      buildTextField(
                        label: "Account No",
                        field: "accountNo",
                        value: group.accountNo ?? "",
                        onChange: (value) {
                          group.accountNo = value;
                        },
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      buildTextField(
                        label: "IFSC Code",
                        field: "ifscCode",
                        value: group.ifscCode ?? "",
                        onChange: (value) {
                          group.ifscCode = value;
                        },
                      ),
                      buildDateField(
                        label: "Account Opening Date",
                        field: "accountOpeningDate",
                        value: group.accountOpeningDate,
                        onChange: (value) {
                          setState(() {
                            group.accountOpeningDate = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
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
              updatedRows = await dao.addGroup(group);
            } else {
              updatedRows = await dao.updateGroup(group);
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
