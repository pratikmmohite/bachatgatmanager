import 'package:bachat_gat/common/common_index.dart';
import 'package:bachat_gat/features/groups/models/models_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'getFontLoad.dart';

class PdfApi {
  static final headers = [
    'Month',
    'Paid Shares',
    'Loan Taken',
    'Paid Interest',
    'Paid Loan',
    'Remaining Loan',
    'Late Fee',
    'Others',
    'Total Paid'
  ];
  static pw.Page page(String groupName, String memberName, dynamic data) {
    return pw.Page(
      build: (context) {
        return pw.Column(
          children: [
            pw.Text(groupName,
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                )),
            pw.SizedBox(height: 20),
            pw.Column(
              children: [
                pw.Text("Member Name: $memberName",
                    style: pw.TextStyle(
                      fontSize: 15,
                      fontWeight: pw.FontWeight.normal,
                      fontStyle: pw.FontStyle.normal,
                    ))
              ],
            ),
            pw.SizedBox(height: 15),
            pw.TableHelper.fromTextArray(
              headers: headers,
              data: data,
            ),
          ],
        );
      },
    );
  }

  static Future<Uint8List> generateTable(
      List<List<MemberTransactionDetails>> memberData,
      List<String> memberName,
      String groupName,
      double remainingLoan,
      BuildContext context) async {
    // Create the Font object
    final rfont = await FontLoaders.loadFont(
        'assets/fonts/NotoSansDevanagari-Regular.ttf');
    final mfont = await FontLoaders.loadFont(
        'assets/fonts/NotoSansDevanagari-Medium.ttf');
    final bfont =
        await FontLoaders.loadFont('assets/fonts/NotoSansDevanagari-Bold.ttf');
    final sbfont = await FontLoaders.loadFont(
        'assets/fonts/NotoSansDevanagari-SemiBold.ttf');
    final nfont = await FontLoaders.loadFont('assets/fonts/marathi.ttf');
    // Create the ThemeData with the loaded font
    var myTheme = pw.ThemeData.withFont(
      base: rfont,
      bold: bfont,
      fontFallback: [nfont, mfont, sbfont],
    );
    final pdf = pw.Document(
      theme: myTheme,
    );
    // final headers = [
    //   'Month',
    //   'Paid Shares',
    //   'Loan Taken',
    //   'Paid Interest',
    //   'Paid Loan',
    //   'Remaining Loan',
    //   'Late Fee',
    //   'Others',
    //   'Total Paid'
    // ];
    List<pw.Widget> datal = [];
    List<double> totalPaid = [];
    int i = 0;
    for (var member in memberData) {
      for (var m in member) {
        double total = m.paidOtherAmount! +
            m.paidInterest! +
            m.paidLoan! +
            m.paidLateFee! +
            m.paidShares!;
        totalPaid.add(total);
      }
      final data = member
          .asMap()
          .entries
          .map((entry) => [
                entry.value.trxPeriod ?? '',
                entry.value.paidShares?.toString() ?? '',
                entry.value.loanTaken?.toString() ?? '',
                entry.value.paidInterest?.toString() ?? '',
                entry.value.paidLoan?.toString() ?? '',
                entry.value.remainingLoan?.toString() ?? '',
                entry.value.paidLateFee?.toString() ?? '',
                entry.value.paidOtherAmount?.toString() ?? '',
                totalPaid[entry.key]
                    .toString(), // Add totalPaid for each member
              ])
          .toList();
      datal.add(page(groupName, memberName[i], data) as pw.Widget);
      i += 1;
    }

    // final data = memberData
    //     .asMap()
    //     .entries
    //     .map((entry) => [
    //           entry.value.trxPeriod ?? '',
    //           entry.value.paidShares?.toString() ?? '',
    //           entry.value.loanTaken?.toString() ?? '',
    //           entry.value.paidInterest?.toString() ?? '',
    //           entry.value.paidLoan?.toString() ?? '',
    //           entry.value.remainingLoan?.toString() ?? '',
    //           entry.value.paidLateFee?.toString() ?? '',
    //           entry.value.paidOtherAmount?.toString() ?? '',
    //           totalPaid[entry.key].toString(), // Add totalPaid for each member
    //         ])
    //     .toList();

    pdf.addPage(
      pw.MultiPage(
        build: (context) {
          return datal;
        },
      ),
    );
    return pdf.save();
  }

  static Future<void> previewPDF(Uint8List bytes) async {
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) => bytes);
  }

  static Future<void> saveAsPDF(String fileName, Uint8List bytes) async {
    await AppUtils.saveAsBytes(fileName, "pdf", bytes);
  }
}
