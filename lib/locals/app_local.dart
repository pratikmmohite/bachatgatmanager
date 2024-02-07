abstract class AppLocalization {
  Map<String, String> defaultLocalMap = {
    "appTitle": "Saving Group",
    "abAddLoan": "Add Loan",
    "abAddMember": "Add Member",
    "abRecordTransaction": "Record transaction",
    "abMemberList": "Members",
    "abLoanList": "Loan List",
    "abAddGroup": "Add Group",
    "abImportExport": "Import/Export Data",
    "mRecordedLoanPaymentSuccess": "Recorded loan payment successfully",
    "mRecordedSharePaymentSuccess": "Recorded share payment successfully",
    "mRecordedTrxPaymentSuccess": "Recorded transaction successfully",
    "mSelectLoan": "Please select loan",
    "mEnterLoanAmount": "Please enter loan amount",
    "mEnterShareAmount": "Please enter share amount",
    "bImportFile": "Import Data",
    "bExportFile": "Export Data",
    "bSave": "Save",
    "bGiveLoan": "Give loan",
    "bRecord": "Record",
    "bAddShare": "Add Share",
    "bAddLoan": "Give new loan",
    "bShowLoans": "Show Loans",
    "bShowTransactions": "Show transactions",
    "tfEnterLoanAmt": "Enter loan amount",
    "tfEnterLoanInterest": "Enter loan interest",
    "tfEnterNote": "Enter note",
    "tfGroupName": "Group Name",
    "tfStartDate": "Start Date",
    "tfEndDate": "End Date",
    "tfAddress": "Address",
    "tfBankName": "Bank Name",
    "tfAccountNot": "Account No",
    "tfIfscCode": "IFSC Code",
    "tfAccountOpeningDt": "Account Opening Date",
    "tfGroupSettings": "Group Settings",
    "tfInstallmentAmt": "Installment Amount",
    "tfLoanAmt": "Loan Amount",
    "tfLoanInterest": "Loan Interest",
    "tfLateFee": "Late Fee",
    "tfShareAmount": "Share Amount",
    "tfSelectLoanToPay": "Select loan to pay",
    "tfMemberName": "Member Name",
    "tfMobileNo": "Mobile No",
    "tfAadherNo": "Aadhar No",
    "tfPanNo": "Pan No",
    "tfJoiningDate": "Joining Date",
    "lLoanAmt": "Loan Amount",
    "lLoanInterest": "Loan Interest",
    "lPaidLoan": "Paid Loan",
    "lPaidInterest": "Paid Interest",
    "lPaidShare": "Paid Share",
    "lPaidLateFee": "Paid Late Fee",
    "lLateFee": "Late Fee",
    "lShareAmount": "Share Amount",
    "lRmLoan": "Remaining Loan(-)",
    "lNote": "Note",
    "lBalance": "Balance",
    "lLoan": "Loan(+)",
    "lGivenLoan": "Loan(-)",
    "lShare": "Share(+)",
    "lMember": "Member",
    "lTotal": "Total",
    "lRemaining": "Remaining",
    "lInterest": "Interest(+)",
    "lPenalty": "Penalty(+)",
    "lOthers": "Others(+)",
    "lActions": "Actions"
  };
  List<String> get months => [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sept",
        "Oct",
        "Nov",
        "Dec",
      ];

  Map<String, String> get languageSpecificMap;

  String getValue(String k) {
    return languageSpecificMap[k] ?? defaultLocalMap[k] ?? k;
  }

  String getHumanTrxPeriod(DateTime dt) {
    return "${months[dt.month - 1]}-${dt.year}";
  }

  // App Titles
  String get appTitle => getValue("appTitle");
  // AppBar Titles
  String get abAddMember => getValue("abAddMember");
  String get abAddLoan => getValue("abAddLoan");
  String get abRecordTransaction => getValue("abRecordTransaction");
  String get abMemberList => getValue("abMemberList");
  String get abLoanList => getValue("abLoanList");
  String get abAddGroup => getValue("abAddGroup");
  String get abImportExport => getValue("abImportExport");
  // Messages
  String get mLoanSuccess => getValue("mLoanSuccess");
  String get mRecordedLoanPaymentSuccess =>
      getValue("mRecordedLoanPaymentSuccess");
  String get mRecordedSharePaymentSuccess =>
      getValue("mRecordedSharePaymentSuccess");
  String get mRecordedTrxPaymentSuccess =>
      getValue("mRecordedTrxPaymentSuccess");
  String get mSelectLoan => getValue("mSelectLoan");
  String get mEnterLoanAmount => getValue("mEnterLoanAmount");
  String get mEnterShareAmount => getValue("mEnterShareAmount");
  // Buttons
  String get bGiveLoan => getValue("bGiveLoan");
  String get bImportFile => getValue("bImportFile");
  String get bExportFile => getValue("bExportFile");
  String get bSave => getValue("bSave");
  String get bRecord => getValue("bRecord");
  String get bAddShare => getValue("bAddShare");
  String get bAddLoan => getValue("bAddLoan");
  String get bShowLoans => getValue("bShowLoans");
  String get bShowTransactions => getValue("bShowTransactions");
  // Input Fields
  String get tfEnterLoanAmt => getValue("tfEnterLoanAmt");
  String get tfEnterLoanInterest => getValue("tfEnterLoanInterest");
  String get tfEnterNote => getValue("tfEnterNote");
  String get tfGroupName => getValue("tfGroupName");
  String get tfStartDate => getValue("tfStartDate");
  String get tfEndDate => getValue("tfEndDate");
  String get tfAddress => getValue("tfAddress");
  String get tfBankName => getValue("tfBankName");
  String get tfAccountNot => getValue("tfAccountNot");
  String get tfIfscCode => getValue("tfIfscCode");
  String get tfAccountOpeningDt => getValue("tfAccountOpeningDt");
  String get tfGroupSettings => getValue("tfGroupSettings");
  String get tfInstallmentAmt => getValue("tfInstallmentAmt");
  String get tfLoanAmt => getValue("tfLoanAmt");
  String get tfLoanInterest => getValue("tfLoanInterest");
  String get tfLateFee => getValue("tfLateFee");
  String get tfShareAmount => getValue("tfShareAmount");
  String get tfSelectLoanToPay => getValue("tfSelectLoanToPay");
  String get tfMemberName => getValue("tfMemberName");
  String get tfMobileNo => getValue("tfMobileNo");
  String get tfAadherNo => getValue("tfAadherNo");
  String get tfPanNo => getValue("tfPanNo");
  String get tfJoiningDate => getValue("tfJoiningDate");
  // Labels
  String get lBalance => getValue("lBalance");
  String get lLoan => getValue("lLoan");
  String get lGivenLoan => getValue("lGivenLoan");
  String get lShare => getValue("lShare");
  String get lMember => getValue("lMember");
  String get lTotal => getValue("lTotal");
  String get lInterest => getValue("lInterest");
  String get lPenalty => getValue("lPenalty");
  String get lOthers => getValue("lOthers");
  String get lActions => getValue("lActions");
  String get lLoanAmt => getValue("lLoanAmt");
  String get lLoanInterest => getValue("lLoanInterest");
  String get lPaidLoan => getValue("lPaidLoan");
  String get lPaidInterest => getValue("lPaidInterest");
  String get lPaidLateFee => getValue("lPaidLateFee");
  String get lPaidShare => getValue("lPaidShare");
  String get lLateFee => getValue("lLateFee");
  String get lShareAmount => getValue("lShareAmount");
  String get lRmLoan => getValue("lRmLoan");
  String get lNote => getValue("lNote");
}

class EnAppLocalization extends AppLocalization {
  @override
  Map<String, String> get languageSpecificMap => {};
}

class MrAppLocalization extends AppLocalization {
  @override
  Map<String, String> get languageSpecificMap => {
        "appTitle": "बचत गट",
        "abAddLoan": "कर्ज जोडा",
        "abAddMember": "सदस्य जोडा",
        "abRecordTransaction": "लेन-देन नोंदणी करा",
        "abMemberList": "सदस्य",
        "abLoanList": "कर्ज",
        "abAddGroup": "समूह जोडा",
        "abImportExport": "आयात/निर्यात डेटा",
        "mRecordedLoanPaymentSuccess": "कर्ज भुगतान सफळतेने नोंदणी केली",
        "mRecordedSharePaymentSuccess": "शेअर भुगतान सफळतेने नोंदणी केली",
        "mSelectLoan": "कृपया कर्ज निवडा",
        "mEnterLoanAmount": "कृपया कर्ज रक्कम प्रविष्ट करा",
        "mEnterShareAmount": "कृपया शेअर रक्कम प्रविष्ट करा",
        "bImportFile": "डेटा आयात करा",
        "bExportFile": "डेटा निर्यात करा",
        "bSave": "सेव्ह",
        "bGiveLoan": "कर्ज द्या",
        "bRecord": "नोंदणी करा",
        "bAddShare": "शेअर जोडा",
        "bAddLoan": "कर्ज जोडा",
        "bShowLoans": "कर्ज दाखवा",
        "tfEnterLoanAmt": "कर्ज रक्कम प्रविष्ट करा",
        "tfEnterLoanInterest": "कर्ज व्याज प्रविष्ट करा",
        "tfEnterNote": "टीप प्रविष्ट करा",
        "tfGroupName": "समूहाचे नाव",
        "tfStartDate": "सुरूवातीची तारीख",
        "tfEndDate": "शेवटची तारीख",
        "tfAddress": "पत्ता",
        "tfBankName": "बँकचे नाव",
        "tfAccountNot": "खाते क्रमांक",
        "tfIfscCode": "IFSC कोड",
        "tfAccountOpeningDt": "खाते उघडण्याची तारीख",
        "tfGroupSettings": "समूह सेटिंग्ज",
        "tfInstallmentAmt": "किशोर रक्कम",
        "tfLoanAmt": "कर्ज रक्कम",
        "tfLoanInterest": "कर्ज व्याज",
        "tfLateFee": "उशिर शुल्क",
        "tfShareAmount": "शेअर रक्कम",
        "tfSelectLoanToPay": "भुगतान करण्यासाठी कर्ज निवडा",
        "tfMemberName": "सदस्याचे नाव",
        "tfMobileNo": "मोबाइल नंबर",
        "tfAadherNo": "आधार नंबर",
        "tfPanNo": "पॅन नंबर",
        "tfJoiningDate": "सामील होण्याची तारीख",
        "lLoanAmt": "कर्ज रक्कम",
        "lLoanInterest": "कर्ज व्याज",
        "lPaidLoan": "भुगतान केलेला कर्ज",
        "lPaidInterest": "भुगतान केलेला व्याज",
        "lLateFee": "उशिर शुल्क",
        "lShareAmount": "शेअर रक्कम",
        "lRmLoan": "बाकी कर्ज (-)",
        "lNote": "टिप",
        "lBalance": "शिल्लक",
        "lLoan": "कर्ज",
        "lPaidShare": "भुगतान केलेला शेअर",
        "lPaidLateFee": "भुगतान केलेला दंड",
        "lShare": "शेअर",
        "lMember": "सदस्य",
        "lTotal": "एकूण",
        "lRemaining": "शेष",
        "lInterest": "व्याज",
        "lPenalty": "दंड",
        "lOthers": "इतर",
        "lActions": "क्रिया"
      };

  @override
  List<String> get months => [
        "जानेवारी",
        "फेब्रुवारी",
        "मार्च",
        "एप्रिल",
        "मे",
        "जून",
        "जुलै",
        "ऑगस्ट",
        "सप्टेंबर",
        "ऑक्टोबर",
        "नोव्हेंबर",
        "डिसेंबर"
      ];

  @override
  String getHumanTrxPeriod(DateTime dt) {
    return "${months[dt.month - 1]}-${dt.year}";
  }
}
