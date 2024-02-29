import 'dart:io';

import 'package:bachat_gat/common/common_index.dart';
import 'package:pdf/widgets.dart' as pw;

abstract class PdfGenerationBase {
  late String dirPath;
  late String fileName;
  late pw.Document pdfDocument;

  PdfGenerationBase({required this.fileName}) {
    dirPath = getDirPath().toString();
  }

  Future<String> getDirPath() async {
    return await AppUtils.getDocumentDirectory();
  }

  String getFilePath(String fileName) {
    return getDirPath().toString() + fileName;
  }

  void prepareData() {
    // This method will handle data gathering from data base or other sources
  }

  void processData() {
    // This method will write data prepared by processData into pw.Document variable
  }

  void saveFile(List<int> pdfBytes) {
    final filePath = getFilePath(fileName);
    final file = File(filePath);
    file.writeAsBytes(pdfBytes);
  }

  void init() async {
    prepareData();
    processData();
  }
}
