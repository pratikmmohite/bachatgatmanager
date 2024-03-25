import 'package:bachat_gat/common/common_index.dart';
import 'package:bachat_gat/features/groups/models/models_index.dart';
import 'package:bachat_gat/locals/app_local_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'getFontLoad.dart';

class PdfApi {
  static Future<Uint8List> generateTable(
      List<MemberTransactionDetails> memberData,
      String memberName,
      String groupName,
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
    var local = AppLocal.of(context as BuildContext);
    // var previouRemainigLoan = 0.0;
    final headers2 = [
      local.lmonth,
      local.lShare,
      local.lPaidLoan,
      local.lPaidInterest,
      local.lPenalty,
      local.lOthers,
      local.lTotal,
      local.lGivenLoan,
      local.lRmLoan,
    ];
    // final headers = [
    //   'Month',
    //   'Shares',
    //   'Loan Taken',
    //   'Paid Interest',
    //   'Paid Loan',
    //   'Remaining Loan',
    //   'Late Fee',
    //   'Others',
    //   'Total Paid'
    // ];

    List<double> totalPaid = [];
    for (var m in memberData) {
      double total = m.paidOtherAmount! +
          m.paidInterest! +
          m.paidLoan! +
          m.paidLateFee! +
          m.paidShares!;
      totalPaid.add(total);
    }

    final data = memberData.asMap().entries.map(
      (entry) {
        final previousRemainingLoan =
            entry.key > 0 ? memberData[entry.key - 1].remainingLoan : 0;
        final paidLoan = entry.value.paidLoan ?? 0;
        final remainingLoan =
            entry.value.loanTaken! + previousRemainingLoan! - paidLoan;

        return [
          entry.value.trxPeriod ?? '0.0',
          entry.value.paidShares?.toString() ?? '0.0',
          entry.value.paidLoan?.toString() ?? '0.0',
          entry.value.paidInterest?.toString() ?? '0.0',
          entry.value.paidLateFee?.toString() ?? '0.0',
          entry.value.paidOtherAmount?.toString() ?? '',
          totalPaid[entry.key].toString(),
          entry.value.loanTaken?.toString() ?? '0.0',
          remainingLoan.toString(),

          // Add totalPaid for each member
        ];
      },
    ).toList();

    pdf.addPage(
      pw.Page(
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
                headers: headers2,
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
                data: data,
                cellAlignment: pw.Alignment.centerLeft,
                cellStyle: pw.TextStyle(fontSize: 10),
                // Setting equal width for each column
                columnWidths: {
                  for (int columnIndex = 0;
                      columnIndex < headers2.length;
                      columnIndex++)
                    columnIndex: pw.FixedColumnWidth(
                        40.0), // Adjust the width as per your requirement
                },
              ),
            ],
          );
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
