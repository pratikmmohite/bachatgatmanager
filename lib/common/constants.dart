class AppConstants {
  // Trx Types
  static const String ttShare = "Share";
  static const String ttLoan = "Loan";
  static const String ttLateFee = "LateFee";
  static const String ttLoanInterest = "LoanInterest";
  static const String ttOthers = "Others";
  static const String ttBankFee = "BankFee";
  static const String ttBankInterest = "BankInterest";
  static const String ttExpenditures = "BankInterest";
  static const String ttBankDeposit = "BankDeposit";
  static const String ttOpeningBalance = "Opening Balance";
  static const String ttClosingBalance = "Closing Balance";
  static String dbCreditFilter =
      "('${[ttShare, ttLateFee, ttLoanInterest, ttOthers].join("','")}')";
  static String dbDebitFilter =
      "('${[ttBankFee, ttExpenditures].join("','")}')";
  // Loan status
  static const String lsActive = "Active";
  static const String lsComplete = "Complete";

  // Transaction Dialog Mode
  static const String tmPayment = "Payment";
  static const String tmBoth = "Record Payment";
  static const String tmLoan = "Loan Payment";

  // TrxSources
  static const String sLoan = "Loan";
  static const String sUser = "User";

  static const String sfViewMode = "sfViewMode";

  static const List<String> cEnMonthsStr = [
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
}
