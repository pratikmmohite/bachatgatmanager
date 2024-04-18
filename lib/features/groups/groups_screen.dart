/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:bachat_gat/common/common_index.dart';
import 'package:bachat_gat/features/groups/pages/save_data/import_export_page.dart';
import 'package:flutter/material.dart';

import '../../locals/app_local_delegate.dart';
import 'pages/group/group_add_page.dart';
import 'pages/group/groups_list_page.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final groupKey = GlobalKey<GroupsListPageState>();
  Future<void> refreshGroupList() async {
    await groupKey.currentState?.getGroups();
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocal.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppConstants.imgAppIcon,
              height: 50,
            ),
            Text(local.appTitle),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.import_export),
            onPressed: () async {
              await AppUtils.navigateTo(context, const ImportExportPage());
              refreshGroupList();
            },
          ),
          ValueListenableBuilder(
            valueListenable: AppLocal.l(),
            builder: (context, local, child) {
              String changeTo = local.languageCode == "en" ? "mr" : "en";
              return TextButton(
                onPressed: () {
                  AppLocal.c(changeTo);
                },
                child: Text(changeTo),
              );
            },
            child: TextButton(
              onPressed: () {
                AppLocal.c("en");
              },
              child: const Text("en"),
            ),
          ),
        ],
      ),
      body: GroupsListPage(
        key: groupKey,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ct) => const GroupAddPage(),
            ),
          );
          await refreshGroupList();
        },
        label: Text(local.bAddGroup),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
