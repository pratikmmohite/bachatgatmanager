import 'dart:io';

import 'package:bachat_gat/features/groups/models/models_index.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfApi {
  // Method to generate centered text
  static Future<void> generateCenteredText(String text) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Center(
          child: pw.Text(text, style: const pw.TextStyle(fontSize: 48)),
        ),
      ),
    );
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  // Method to save generated PDF document
  static Future<File> saveDocument(
      {required String name, required pw.Document pdf}) async {
    final bytes = await pdf.save();
    final dir = await getDownloadsDirectory();
    final file = File('${dir!.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  // Method to generate table with member transaction details
  static Future<void> generateTable(List<MemberTransactionDetails> memberData,
      String MemberName, String groupName) async {
    final pdf = pw.Document();
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

    pdf.addPage(pw.Page(build: (Context) {
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
              pw.Text("Member Name: $MemberName",
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

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }
}

// // import 'dart:html';
//
// import 'dart:io';
//
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
//
// // class PdfApi {}
//
// class User {
//   final String name;
//   final String age;
//   const User({required this.name, required this.age});
// }
//
// class PdfApi {
//   static Future<void> generateCenteredText(String text) async {
//     final pdf = pw.Document();
//     pdf.addPage(
//       pw.Page(
//           build: (context) => pw.Center(
//                 child: pw.Text(text, style: const pw.TextStyle(fontSize: 48)),
//               )),
//     );
//     await Printing.layoutPdf(
//         onLayout: (PdfPageFormat format) async => pdf.save());
//     // return await saveDocument(name: 'my_example.pdf', pdf: pdf);
//   }
//
//   static Future<File> saveDocument(
//       {required String name, required pw.Document pdf}) async {
//     final bytes = await pdf.save();
//     final dir = await getDownloadsDirectory();
//     final file = File('${dir!.path}/$name');
//     await file.writeAsBytes(bytes);
//     return file;
//   }
//
//   static Future<void> generateTable() async {
//     final pdf = pw.Document();
//     final headers = [
//       'memberId',
//       'Month',
//       'Paid Shares',
//       'Loan Taken',
//       'Paid Interest',
//       'Paid Loan',
//       'Remaining Loan',
//       'Late Fee',
//       'Others'
//     ];
//     final users = [
//       const User(name: 'John', age: '30'),
//       const User(name: 'Smith', age: '40'),
//       const User(name: 'Hello', age: '45'),
//     ];
//     final data = users.map((user) => [user.name, user.age]).toList();
//     pdf.addPage(pw.Page(build: (Context) {
//       return pw.TableHelper.fromTextArray(
//         headers: headers,
//         data: data,
//       );
//     }));
//     await Printing.layoutPdf(
//         onLayout: (PdfPageFormat format) async => pdf.save());
//   }
// }
//
// // Future<void> pdfApi() async {
// //   final pdf = pw.Document();
// //
// //   pdf.addPage(
// //     pw.Page(
// //       build: (pw.Context context) => pw.Center(
// //         child: pw.Text('Hello World!'),
// //       ),
// //     ),
// //   );
// //
// //   final file = File('example.pdf');
// //   await file.writeAsBytes(await pdf.save());
// // }
