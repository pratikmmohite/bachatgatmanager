/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:bachat_gat/locals/app_local_delegate.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/widgets_index.dart';
import '../../dao/groups_dao.dart';
import '../../models/models_index.dart';

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
    var local = AppLocal.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(local.abAddMember)),
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
                    label: local.tfMemberName,
                    field: "name",
                    value: _groupMember.name,
                    isRequired: true,
                    onChange: (value) {
                      _groupMember.name = value;
                    }),
                CustomTextField(
                  label: local.tfMobileNo,
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
                          label: local.tfAadherNo,
                          field: "aadharNo",
                          value: _groupMember.aadharNo ?? "",
                          onChange: (value) {
                            _groupMember.aadharNo = value;
                          },
                          keyboardType: TextInputType.number,
                        ),
                        CustomTextField(
                          label: local.tfPanNo,
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
                  label: local.tfJoiningDate,
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
        label: Text(local.bSave),
        icon: const Icon(Icons.save),
      ),
    );
  }
}
