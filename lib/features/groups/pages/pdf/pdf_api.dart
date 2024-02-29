import 'package:bachat_gat/common/common_index.dart';
import 'package:bachat_gat/features/groups/models/models_index.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfApi {
  static Future<Uint8List> generateTable(
      List<MemberTransactionDetails> memberData,
      String memberName,
      String groupName) async {
    final fontData = await rootBundle.load('assets/fonts/marathi.ttf');

    // Create the Font object
    final font = pw.Font.ttf(fontData.buffer.asByteData());

    // Create the ThemeData with the loaded font
    var myTheme = pw.ThemeData.withFont(base: font);
    final pdf = pw.Document(
      theme: myTheme,
    );
    final headers = [
      'Month',
      'Paid Shares',
      'Loan Taken',
      'Paid Interest',
      'Paid Loan',
      'Remaining Loan',
      'Late Fee',
      'Others'
    ];

    final data = memberData
        .map((member) => [
              member.trxPeriod ?? '',
              member.paidShares?.toString() ?? '',
              member.loanTaken?.toString() ?? '',
              member.paidInterest?.toString() ?? '',
              member.paidLoan?.toString() ?? '',
              member.remainingLoan?.toString() ?? '',
              member.paidLateFee?.toString() ?? '',
              member.paidOtherAmount?.toString() ?? '',
            ])
        .toList();

    pdf.addPage(pw.Page(build: (context) {
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
    }));
    return pdf.save();
  }

  static Future<void> previewPDF(Uint8List bytes) async {
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) => bytes);
  }

  static Future<void> saveAsPDF(String fileName, Uint8List bytes) async {
    await AppUtils.saveAsBytes(fileName, "pdf", bytes);
  }
}
