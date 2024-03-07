import 'member.dart';

List<Member> generateDummyData() {
  List<Member> dummyData = [];

  for (int i = 1; i <= 20; i++) {
    Member member = Member(
      name: 'Person $i',
      monthlySavings: '100',
      extraSavings: '50',
      loanRepaid: '200',
      serviceCharge: '10',
      penalty: '5',
      otherDeposits: '50',
      totalDeposit: '500',
      givenLoan: '1000',
      loanInterest: '100',
      totalLoanPaid: '500',
      totalSavings: '1000',
      totalExtraSavings: '500',
      savingsBack: '200',
      loanTakenTillDate: '1500',
      totalLoanReturn: '1000',
      remainingLoan: '500',
      totalServiceCharge: '50',
      totalPenalty: '20',
      totalOtherSavings: '100',
    );

    dummyData.add(member);
  }

  return dummyData;
}
