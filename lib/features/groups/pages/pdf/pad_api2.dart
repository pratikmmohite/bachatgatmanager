import 'package:bachat_gat/common/common_index.dart';
import 'package:bachat_gat/features/groups/models/models_index.dart';
import 'package:bachat_gat/locals/app_local_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../dao/groups_dao.dart';
import 'getFontLoad.dart';

class NewPdfApi {
  static Future<Uint8List> generatePdf(
      {required String memberId,
      required String groupId,
      required DateTime startDate,
      required DateTime endDate,
      required String memberName,
      required String groupName,
      required BuildContext context}) async {
    final dao = GroupsDao();
    final data = await dao.getMemberDetailsByMemberId(
        memberId,
        groupId,
        AppUtils.getTrxPeriodFromDt(startDate),
        AppUtils.getTrxPeriodFromDt(endDate));

    return generateTable(data, memberName, groupName, context);
  }

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
    var local = AppLocal.of(context);
    // var previouRemainigLoan = 0.0;
    final headers = [
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
        return [
          entry.value.trxPeriod ?? '0.0',
          entry.value.paidShares?.toString() ?? '0.0',
          entry.value.paidLoan?.toString() ?? '0.0',
          entry.value.paidInterest?.toString() ?? '0.0',
          entry.value.paidLateFee?.toString() ?? '0.0',
          entry.value.paidOtherAmount?.toString() ?? '',
          totalPaid[entry.key].toString(),
          entry.value.loanTaken?.toString() ?? '0.0',
          entry.value.remainingLoan?.toString() ?? '0.0',
          // Add totalPaid for each member
        ];
      },
    ).toList();
    print(data[0][0]);
    var body = '''
    <!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <style>
             h2,h1{
                text-align: center;
             } 
             
           
        table {
            margin: auto;
            border-collapse: collapse;
        }
 
        td,th{
            border: 1px solid black;
            padding: 10px;
            justify-content: center;
            text-align: center;
            align-items: center;
        }

    
    </style>
</head>
    <body>
         <h1 style="text-align:center; font-size:1px"> ${local.tfGroupName} : $groupName </h1>
         <h2 style="text-align:center; font-size:1px;" > ${local.lMemberName}: $memberName </h2>
         <div style=" justify-content:center;">
           <table style="border: 1px solid black; text-align:center;font-size:2px;">
             <thead style="border: 1px solid black;">
                 <tr>
                    <th>${local.lmonth}</th>
                    <th>${local.lShare}</th>
                    <th>${local.lPaidLoan}</th>
                    <th>${local.lPaidInterest}</th>
                    <th>${local.lPenalty}</th>
                    <th>${local.lOthers}</th>
                    <th>${local.lTotal}</th>
                    <th>${local.lGivenLoan}</th>
                    <th>${local.lRmLoan}</th>
                 </tr>
                           
             </thead>
             <tbody style="border: 1px solid black;">
             
           ''';

    var tableData = '';

    for (int i = 0; i < data.length; i++) {
      tableData = '''
           <tr>
             <td>${data[i][0]}</td>
             <td>${data[i][1]}</td>
             <td>${data[i][2]}</td>
             <td>${data[i][3]}</td>
             <td>${data[i][4]}</td>
             <td>${data[i][5]}</td>
             <td>${data[i][6]}</td>
             <td>${data[i][7]}</td>
             <td>${data[i][8]}</td>
          </tr>
         ''';
      body = body + tableData;
    }

    var foot = '''
                    </tbody>   
                   </table> 
                   </div>
                 </body>  
      ''';

    var finalBody = body + foot;

    print(finalBody);

    final widgets = await HTMLToPdf().convert(body);
    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4, build: (context) => widgets));
    return await pdf.save();
  }

  static Future<void> previewPDF(Uint8List bytes, String filename) async {
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) => bytes, name: filename);
  }

  static Future<void> sharePDF(Uint8List bytes, String filename) async {
    await Printing.sharePdf(bytes: bytes, filename: filename);
  }

  static Future<void> saveAsPDF(Uint8List bytes, String fileName) async {
    await AppUtils.saveAsBytes(fileName, "pdf", bytes);
  }
}
