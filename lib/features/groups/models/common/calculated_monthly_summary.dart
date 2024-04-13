import '../response/monthly_balance_summary.dart';

class CalculatedMonthlySummary {
  double previousRemainingBalance = 0.0;
  double totalDeposit = 0.0;
  double totalShares = 0.0;
  double paidLoan = 0.0;
  double loanInterest = 0.0;
  double totalPenalty = 0.0;
  double totalOtherDeposit = 0.0;
  double monthlyCredit = 0.0;
  double totalCredit = 0.0;
  double givenLoan = 0.0;
  double totalExpenditures = 0.0;
  double totalDebit = 0.0;
  double monthlyClosingBalance = 0.0;
  double total = 0.0;

  CalculatedMonthlySummary(MonthlyBalanceSummary summary) {
    previousRemainingBalance = summary.peviousRemainigBalance;
    totalDeposit = summary.totalDeposit;
    totalShares = summary.totalShares;
    paidLoan = summary.paidLoan;
    loanInterest = summary.totalLoanInterest;
    totalPenalty = summary.totalPenalty;
    totalOtherDeposit = summary.otherDeposit;
    monthlyCredit = summary.totalDeposit +
        summary.totalShares +
        summary.paidLoan +
        summary.totalLoanInterest +
        summary.totalPenalty +
        summary.otherDeposit;
    totalCredit = monthlyCredit + previousRemainingBalance;
    givenLoan = summary.givenLoan;
    totalExpenditures = summary.totalExpenditures;
    totalDebit = givenLoan + totalExpenditures;
    monthlyClosingBalance = monthlyCredit +
        previousRemainingBalance -
        givenLoan -
        totalExpenditures;
    total = monthlyClosingBalance + givenLoan + totalExpenditures;
  }
}
