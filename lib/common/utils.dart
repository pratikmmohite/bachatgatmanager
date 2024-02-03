import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'constants.dart';

class AppUtils {
  static var uuid = const Uuid();
  static String getUUID() {
    return uuid.v1();
  }

  static void toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }

  static Future<void> navigateTo(BuildContext context, Widget navToWid) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ct) => navToWid,
      ),
    );
  }

  static void close(BuildContext context) {
    Navigator.of(context).pop();
  }

  static String getTrxPeriodFromDt(DateTime dt) {
    return "${AppConstants.cMonthsStr[dt.month - 1]}-${dt.year}";
  }

  static String getHumanReadableDt(DateTime dt) {
    return "${dt.day}-${AppConstants.cMonthsStr[dt.month - 1]}-${dt.year}";
  }

  static String getTrxPeriod(int month, int year) {
    return "${AppConstants.cMonthsStr[month - 1]}-${year}";
  }

  static List<String> getMonthStringsFromDate(DateTime startDate) {
    List<String> monthStrings = [];

    DateTime currentDate = DateTime.now();
    int currentYear = currentDate.year;
    int currentMonth = currentDate.month;

    int startYear = startDate.year;
    int startMonth = startDate.month;

    while (startYear < currentYear ||
        (startYear == currentYear && startMonth <= currentMonth)) {
      String monthYearString = getTrxPeriod(startMonth, startYear);
      monthStrings.add(monthYearString);

      startMonth++;
      if (startMonth > 12) {
        startMonth = 1;
        startYear++;
      }
    }

    return monthStrings;
  }

  static List<String> getMonthStringsFromStartToEndDt(
      DateTime startDate, DateTime endDate) {
    List<String> monthStrings = [];

    int currentYear = endDate.year;
    int currentMonth = endDate.month;

    int startYear = startDate.year;
    int startMonth = startDate.month;

    while (startYear < currentYear ||
        (startYear == currentYear && startMonth <= currentMonth)) {
      String monthYearString = getTrxPeriod(startMonth, startYear);
      monthStrings.add(monthYearString);

      startMonth++;
      if (startMonth > 12) {
        startMonth = 1;
        startYear++;
      }
    }

    return monthStrings;
  }

  static Future<String> saveFile(String name, String filePath) async {
    return await FileSaver.instance.saveFile(filePath: filePath, name: name);
  }

  static Future<String> pickFile([List<String>? allowedExtensions]) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: allowedExtensions,
      allowMultiple: false,
      type: FileType.custom,
    );
    if (result != null) {
      return result.files.single.path!;
    }
    return "";
  }
}
