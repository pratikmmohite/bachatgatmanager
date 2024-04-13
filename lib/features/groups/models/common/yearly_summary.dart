class YearlySummary {
  double previousYearRemainig = 0.0;
  double expenditures = 0.0;
  double totalBankInterest = 0.0;
  double totalcredit = 0.0;

  YearlySummary(double previous, double expenditure, double bankInterest) {
    previousYearRemainig = previous;
    expenditures = expenditure;
    totalBankInterest = bankInterest;
  }
}
