import 'package:bachat_gat/common/common_index.dart';
import 'package:bachat_gat/features/groups/models/models_index.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';

import '../../../dao/dao_index.dart';

class ExcelExample {
  static Future<void> saveAsExcel(String fileName, Uint8List bytes) async {
    await AppUtils.saveAsBytes(fileName, "xlsx", bytes);
  }

  static Future<void> createAndSaveExcel(String groupId, String groupName,
      String startDate, String endDate) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];
    final dao = GroupsDao();
    String previousYearData =
        await dao.getPreviousYearAmount(groupId, startDate);

    String expenditures = await dao.getExpenditures(groupId, startDate);

    String bankInterst = await dao.getBankDepositInterest(groupId, startDate);

    double totalGivenLoan = 0;
    sheetObject.merge(
        CellIndex.indexByString('A1'), CellIndex.indexByString('I1'),
        customValue:
            TextCellValue('जमाखर्च पुस्तक  कालावधी ($startDate - $endDate)'));
    List<double> loanTillToday =
        await dao.getLoanTakenTillToday(groupId, endDate);
    sheetObject.merge(
        CellIndex.indexByString('A2'), CellIndex.indexByString('A3'),
        customValue: const TextCellValue("अ. क्र."));

    sheetObject.merge(
        CellIndex.indexByString('B2'), CellIndex.indexByString('B3'),
        customValue: const TextCellValue("सभासदाचे नाव"));

    sheetObject.merge(
        CellIndex.indexByString('C2'), CellIndex.indexByString('C3'),
        customValue: const TextCellValue('बचत जमा (शेअर्स )'));

    sheetObject.merge(
        CellIndex.indexByString('D2'), CellIndex.indexByString('D3'),
        customValue: const TextCellValue('व्याज '));

    sheetObject.merge(
        CellIndex.indexByString('E2'), CellIndex.indexByString('E3'),
        customValue: const TextCellValue('दंड'));

    sheetObject.merge(
        CellIndex.indexByString('F2'), CellIndex.indexByString('F3'),
        customValue: const TextCellValue('इतर जमा'));

    sheetObject.merge(
        CellIndex.indexByString('G2'), CellIndex.indexByString('G3'),
        customValue: const TextCellValue('एकूण जमा'));

    sheetObject.merge(
        CellIndex.indexByString('H2'), CellIndex.indexByString('H3'),
        customValue: const TextCellValue('आज अखेर घेतलेले कर्ज'));

    sheetObject.merge(
        CellIndex.indexByString('I2'), CellIndex.indexByString('I3'),
        customValue: const TextCellValue('परतफेड कर्ज'));

    sheetObject.merge(
        CellIndex.indexByString('J2'), CellIndex.indexByString('J3'),
        customValue: const TextCellValue('शिल्लक कर्ज'));

    sheetObject.merge(
        CellIndex.indexByString('J2'), CellIndex.indexByString('J3'),
        customValue: const TextCellValue('दिलेले शेअर्स'));

    List<MemberTransactionSummary> dummyData =
        await dao.getYearlySummary(groupId, startDate, endDate);
    List<double> totalDeposit = List<double>.filled(dummyData.length, 0.0);

    for (int i = 0; i < dummyData.length; i++) {
      totalDeposit[i] = (dummyData[i].totalSharesDeposit.toDouble() +
          dummyData[i].totalLoanInterest.toDouble() +
          dummyData[i].totalPenalty.toDouble() +
          dummyData[i].otherDeposit.toDouble());

      totalGivenLoan += loanTillToday[i];
    }

    for (int i = 0; i < dummyData.length; i++) {
      MemberTransactionSummary member = dummyData[i];
      List<String> rowData = [
        (i + 1).toString(),
        member.name,
        member.totalSharesDeposit.toString(),
        member.totalLoanInterest.toString(),
        member.totalPenalty.toString(),
        member.otherDeposit.toString(),
        totalDeposit[i].toString(),
        (loanTillToday[i]).toString(),
        member.loanReturn.toString(),
        (member.loanTakenTillDate - member.loanReturn).toString(),
      ];
      List<CellValue?> rowCells = rowData.map((cellData) {
        return (TextCellValue(cellData.toString()));
      }).toList();

      sheetObject.insertRowIterables(
          rowCells, 4 + i); // Start appending data after 4th row
    }
    var count = 4 + dummyData.length + 1;
    //for displaying the previous remaining amount in savings group
    sheetObject.cell(CellIndex.indexByString('B${count++}')).value =
        const TextCellValue('मागील शिल्लक');
    sheetObject.cell(CellIndex.indexByString('C${count}')).value =
        TextCellValue(previousYearData);

    //for displaying the expenditures of savings group
    sheetObject.cell(CellIndex.indexByString('B${count++}')).value =
        const TextCellValue('इतर खर्च');
    sheetObject.cell(CellIndex.indexByString('C${count}')).value =
        TextCellValue(expenditures);

    //displays the total bank interest deposited by bank
    sheetObject.cell(CellIndex.indexByString('B${count++}')).value =
        const TextCellValue("बँक मधून मिळालेले व्याज");
    sheetObject.cell(CellIndex.indexByString('C${count}')).value =
        TextCellValue(bankInterst);
    //display total given loan till date
    sheetObject.cell(CellIndex.indexByString('B${count++}')).value =
        const TextCellValue("दिलेले कर्ज");
    sheetObject.cell(CellIndex.indexByString('C${count}')).value =
        TextCellValue(totalGivenLoan.toString());

    final fileBytes = excel.save() as Uint8List;

    saveAsExcel(groupName, fileBytes);
    // await previewExcel(fileBytes);
    // saveFile("YearReport.xlsx", fileBytes!);
  }
}
