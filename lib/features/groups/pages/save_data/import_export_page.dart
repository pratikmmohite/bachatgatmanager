import 'dart:io';

import 'package:bachat_gat/common/common_index.dart';
import 'package:bachat_gat/locals/app_local_delegate.dart';
import 'package:flutter/material.dart';

class ImportExportPage extends StatefulWidget {
  const ImportExportPage({super.key});

  @override
  State<ImportExportPage> createState() => _ImportExportPageState();
}

class _ImportExportPageState extends State<ImportExportPage> {
  void exportFile() {
    try {
      var dbService = DbService();
      AppUtils.toast(context, dbService.db.path);
      var dt = DateTime.now();
      String fileName = "${dt.year}_${dt.month}_${dt.day}_bachat_db";
      AppUtils.saveFile(fileName, dbService.db.path);
    } catch (e) {
      AppUtils.toast(context, e.toString());
    }
  }

  Future<void> importFile() async {
    try {
      var newDbFilePath = await AppUtils.pickFile(["sqlite"]);
      if (!newDbFilePath.endsWith(".sqlite")) {
        AppUtils.toast(context, "Select supported file with ext .sqlite");
        return;
      }
      if (newDbFilePath.isNotEmpty) {
        var appDbName = "app_db.sqlite";
        var dbService = DbService();
        String oldDbFile = dbService.db.path;
        dbService.closeDb();
        changeFileNameOnlySync(oldDbFile, "$appDbName.bkp");
        AppUtils.toast(context, "Renamed old file");
        var newFile = File(newDbFilePath);
        newFile.copySync(oldDbFile);
        AppUtils.toast(context, "Coppied new file");
        dbService.initDb();
      }
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
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                importFile();
              },
              icon: const Icon(Icons.upload),
              label: Text(local.bImportFile),
            ),
            const Divider(),
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
