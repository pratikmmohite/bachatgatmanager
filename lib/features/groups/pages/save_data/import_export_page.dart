import 'dart:io';

import 'package:bachat_gat/common/common_index.dart';
import 'package:bachat_gat/locals/app_local_delegate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

class ImportExportPage extends StatefulWidget {
  const ImportExportPage({super.key});

  @override
  State<ImportExportPage> createState() => _ImportExportPageState();
}

class _ImportExportPageState extends State<ImportExportPage> {
  Future<void> exportFile() async {
    try {
      var dbService = DbService();
      var dbFilePath = dbService.dbPath;
      var dt = DateTime.now();
      String fileName = "${dt.year}_${dt.month}_${dt.day}_bachat_db";
      AppUtils.toast(context, dbFilePath);
      print(dbFilePath);
      var x = await AppUtils.saveAsFile(fileName, dbFilePath);
    } catch (e) {
      AppUtils.toast(context, e.toString());
    }
  }

  Future<void> importFile() async {
    try {
      var selectedFile = await AppUtils.pickFile(["sqlite"]);
      if (selectedFile == null ||
          selectedFile.bytes == null ||
          !AppUtils.isSQLiteFile(selectedFile.bytes)) {
        AppUtils.toast(context, "Select supported file with ext .sqlite");
        return;
      }
      var dbService = DbService();
      if (!kIsWeb) {
        await dbService.bkpDb();
      }
      await dbService.closeDb();
      await sqlite.databaseFactory
          .writeDatabaseBytes(dbService.dbPath, selectedFile.bytes!);
      await dbService.initDb();
      AppUtils.toast(context, "Data imported successfully");
      AppUtils.close(context);
    } catch (e) {
      AppUtils.toast(context, e.toString());
    }
  }

  File changeFileNameOnlySync(String oldFilePath, String newFileName) {
    var file = File(oldFilePath);
    var path = file.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    return file.renameSync(newPath);
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocal.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(local.abImportExport),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: OverflowBar(
          alignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                importFile();
              },
              icon: const Icon(Icons.upload),
              label: Text(local.bImportFile),
            ),
            ElevatedButton.icon(
              onPressed: () {
                exportFile();
              },
              icon: const Icon(Icons.download),
              label: Text(local.bExportFile),
            ),
          ],
        ),
      ),
    );
  }
}
