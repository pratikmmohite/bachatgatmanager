import 'package:bachat_gat/features/groups/dao/groups_dao.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/widgets.dart';
import '../models/models_index.dart';

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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                    label: "Member Name",
                    field: "name",
                    value: _groupMember.name,
                    isRequired: true,
                    onChange: (value) {
                      _groupMember.name = value;
                    }),
                CustomTextField(
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
                        CustomTextField(
                          label: "Aadhar No",
                          field: "aadharNo",
                          value: _groupMember.aadharNo ?? "",
                          onChange: (value) {
                            _groupMember.aadharNo = value;
                          },
                          keyboardType: TextInputType.number,
                        ),
                        CustomTextField(
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
                CustomDateField(
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
