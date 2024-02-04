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
    return "${dt.year}-${dt.month.toString().padLeft(2, "0")}";
  }

  static String getHumanReadableDt(DateTime dt) {
    return "${dt.day}-${AppConstants.cEnMonthsStr[dt.month - 1]}-${dt.year}";
  }

  static String getReadableTrxPeriod(DateTime dt) {
    return "${dt.day}-${AppConstants.cEnMonthsStr[dt.month - 1]}-${dt.year}";
  }

  static String getTrxPeriod(int month, int year) {
    return "$year-${AppConstants.cEnMonthsStr[month - 1]}";
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

  static List<DateTime> getMonthsFromStartToEndDt(
      DateTime startDate, DateTime endDate,
      [bool noFuture = false]) {
    List<DateTime> monthStrings = [];
    if (noFuture) {
      var today = DateTime.now();
      if (endDate.year >= today.year && endDate.month >= today.month) {
        endDate = today;
      }
    }
    int currentYear = endDate.year;
    int currentMonth = endDate.month;

    int startDay = startDate.day;
    int startYear = startDate.year;
    int startMonth = startDate.month;

    while (startYear < currentYear ||
        (startYear == currentYear && startMonth <= currentMonth)) {
      monthStrings.add(DateTime(startYear, startMonth, startDay));
      startMonth++;
      if (startMonth > 12) {
        startMonth = 1;
        startYear++;
      }
    }

    return monthStrings;
  }

  static Future<String?> saveFile(String name, String filePath) async {
    String ext = filePath.split(".").last;
    var s = await FileSaver.instance.saveAs(
        filePath: filePath, name: name, ext: ext, mimeType: MimeType.other);
    return s;
  }

  static Future<String> pickFile([List<String>? allowedExtensions]) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: [],
      allowMultiple: false,
      type: FileType.any,
    );
    if (result != null) {
      return result.files.single.path!;
    }
    return "";
  }
}
