import 'package:bachat_gat/common/constants.dart';
import 'package:bachat_gat/common/utils.dart';

import '../../../common/db_service.dart';
import '../models/models_index.dart';

class GroupsDao {
  var dbService = DbService();
  String groupTableName = "groups";
  String memberTableName = "members";
  String transactionTableName = "transactions";
  String loanTableName = "loans";

  Future<int> addGroup(Group group) async {
    var row = await dbService.insert(groupTableName, group.toJson());
    return row;
  }

  Future<int> updateGroup(Group group) async {
    var row = await dbService.update(groupTableName, group.toJson(),
        where: "id = ?", whereArgs: [group.id]);
    return row;
  }

  Future<int> deleteGroup(Group group) async {
    var row = await dbService
        .delete(loanTableName, where: "groupId = ?", whereArgs: [group.id]);
    row += await dbService.delete(transactionTableName,
        where: "groupId = ?", whereArgs: [group.id]);
    row += await dbService
        .delete(memberTableName, where: "id = ?", whereArgs: [group.id]);
    row += await dbService
        .delete(groupTableName, where: "id = ?", whereArgs: [group.id]);
    return row;
  }

  Future<List<Group>> getGroups() async {
    var rows = await dbService.read("select * from $groupTableName");
    var groups = rows.map((e) => Group.fromJson(e)).toList();
    return groups;
  }

  Future<int> addGroupMember(GroupMember member) async {
    var row = await dbService.insert(memberTableName, member.toJson());
    return row;
  }

  Future<int> updateGroupMember(GroupMember member) async {
    var row = await dbService.update(memberTableName, member.toJson(),
        where: "id = ?", whereArgs: [member.id]);
    return row;
  }

  Future<List<Transaction>> getTransactions(
      String groupId, String memberId) async {
    String query = "select * from $transactionTableName "
        "where groupId = ? and memberId = ? "
        "order by trxDt desc";
    List<String> pars = [groupId, memberId];
    var rows = await dbService.read(query, pars);
    var transactions = rows.map((e) => Transaction.fromJson(e)).toList();
    return transactions;
  }

  Future<int> addTransaction(Transaction trx) async {
    var row = await dbService.insert(transactionTableName, trx.toJson());
    if (trx.trxType == AppConstants.ttLoan ||
        trx.trxType == AppConstants.ttLoanInterest) {
      recalculateLoanAmounts(trx.sourceId);
    }
    return row;
  }

  Future<int> deleteTransaction(Transaction trx) async {
    var row = await dbService.delete(
      transactionTableName,
      where: "id = ?",
      whereArgs: [trx.id],
    );
    if (trx.trxType == AppConstants.ttLoan ||
        trx.trxType == AppConstants.ttLoanInterest) {
      recalculateLoanAmounts(trx.sourceId);
    }
    return row;
  }

  Future<int> deleteLoan(Loan loan) async {
    var row = await dbService.delete(
      loanTableName,
      where: "id = ?",
      whereArgs: [loan.id],
    );
    await dbService.delete(
      transactionTableName,
      where: "trxType in (?, ?) and sourceId = ? and sourceType = ?",
      whereArgs: [
        AppConstants.ttLoan,
        AppConstants.ttLoanInterest,
        loan.id,
        AppConstants.sLoan,
      ],
    );
    return row;
  }

  Future<int> recalculateLoanAmounts(String loanId) async {
    String trxQuery = "select ifnull(sum(cr), 0) from $transactionTableName t "
        "where t.trxType = ? and t.sourceType = ? and t.sourceId = ?";
    String query = "update $loanTableName set "
        "paidLoanAmount = ($trxQuery), "
        "paidInterestAmount = ($trxQuery) "
        "where id = ?";
    List<String> pars = [
      AppConstants.ttLoan,
      AppConstants.sLoan,
      loanId,
      AppConstants.ttLoanInterest,
      AppConstants.sLoan,
      loanId,
      loanId
    ];
    var row = await dbService.write(query, pars);
    return row;
  }

  Future<int> addLoan(Loan loan) async {
    var row = await dbService.insert(loanTableName, loan.toJson());
    var trxPeriod = AppUtils.getTrxPeriodFromDt(loan.loanDate);
    var trx = Transaction(
      memberId: loan.memberId,
      groupId: loan.groupId,
      trxType: AppConstants.ttLoan,
      trxPeriod: trxPeriod,
      cr: 0,
      dr: loan.loanAmount,
      sourceType: AppConstants.sLoan,
      sourceId: loan.id,
      addedBy: loan.addedBy,
      note: loan.note,
    );
    addTransaction(trx);
    return row;
  }

  Future<int> updateLoanPaid(Loan loan) async {
    String updateQuery = "update loans set "
        "paidLoanAmount = paidLoanAmount + ?, "
        "paidInterestAmount = paidInterestAmount + ?, "
        "status = iif(paidLoanAmount >= loanAmount, '${AppConstants.lsComplete}', '${AppConstants.lsActive}') "
        "where id = ?";
    var row = await dbService.write(
      updateQuery,
      [
        loan.paidLoanAmount,
        loan.paidInterestAmount,
        loan.id,
      ],
    );
    return row;
  }

  Future<int> deleteGroupMember(GroupMember member) async {
    var row = await dbService
        .delete(loanTableName, where: "memberId = ?", whereArgs: [member.id]);
    row = await dbService.delete(transactionTableName,
        where: "memberId = ?", whereArgs: [member.id]);
    row = await dbService
        .delete(memberTableName, where: "id = ?", whereArgs: [member.id]);
    return row;
  }

  Future<List<GroupMember>> getMembers(MemberFilter filter) async {
    var rows = await dbService.read(
      "select * from $memberTableName "
      "where groupId = ?",
      [filter.groupId],
    );
    var members = rows.map((e) => GroupMember.fromJson(e)).toList();
    return members;
  }

  Future<List<Loan>> getMemberLoans(MemberLoanFilter filter) async {
    String selectClause = "select * "
        "from $loanTableName ";
    List<Object?> pars = [
      filter.memberId,
      filter.groupId,
    ];
    String whereClause = "where memberId = ? "
        "and groupId = ? ";
    if (filter.status.isNotEmpty) {
      whereClause += "and status = ? ";
      pars.add(filter.status);
    }
    String query = selectClause + whereClause;
    var rows = await dbService.read(query, pars);
    var loans = rows.map((e) => Loan.fromJson(e)).toList();
    return loans;
  }

  Future<List<GroupMemberDetails>> getGroupMembersWithBalance(
      MemberBalanceFilter filter) async {
    String balanceAmount = "(select ifnull(sum(t.cr-t.dr), 0) "
        "from $transactionTableName t "
        "where t.groupId = m.groupId "
        "and t.memberId = m.id "
        ") as balance ";

    String paidShareAmount =
        "(${getAmountQuery(AppConstants.ttShare, filter.trxPeriod)}) as paidShareAmount ";
    String paidLoanAmount =
        "(${getAmountQuery(AppConstants.ttLoan, filter.trxPeriod)}) as paidLoanAmount ";
    String paidLateFee =
        "(${getAmountQuery(AppConstants.ttLateFee, filter.trxPeriod)}) as paidLateFee ";
    String paidOtherAmount =
        "(${getAmountQuery(AppConstants.ttOthers, filter.trxPeriod)}) as paidOtherAmount ";
    String paidLoanInterestAmount =
        "(${getAmountQuery(AppConstants.ttLoanInterest, filter.trxPeriod)}) as paidLoanInterestAmount ";
    String givenLoanAmount =
        "(${getAmountQuery(AppConstants.ttLoan, filter.trxPeriod, "dr")}) as lendLoan ";

    String pendingLoanAmount = "(select ifnull(sum(t.dr-t.cr), 0) "
        "from $transactionTableName t "
        "where t.groupId = m.groupId "
        "and t.memberId = m.id "
        "and t.trxPeriod <= '${filter.trxPeriod}' "
        "and t.trxType = '${AppConstants.ttLoan}' ) as pendingLoanAmount ";

    String selectQuery = "select m.name "
        ",m.groupId "
        ",m.id as memberId "
        ",$paidShareAmount "
        ",$paidLoanAmount "
        ",$paidLateFee "
        ",$paidLoanInterestAmount "
        ",$paidOtherAmount "
        ",$balanceAmount "
        ",$givenLoanAmount "
        ",$pendingLoanAmount "
        "from $memberTableName m ";

    String whereClause = "where m.groupId = ? ";
    List<Object?> pars = [filter.groupId];
    if (filter.memberId.isNotEmpty) {
      whereClause += "and m.id = ? ";
      pars.add(filter.memberId);
    }
    String query = selectQuery + whereClause;
    var rows = await dbService.read(query, pars);
    var members = rows.map((e) => GroupMemberDetails.fromJson(e)).toList();
    return members;
  }

  Future<List<GroupSummary>> getGroupSummary(GroupSummaryFilter filter) async {
    String selectQuery = "select trx.groupId "
        ",trx.trxPeriod "
        ",trx.trxType "
        ",sum(trx.cr) as totalCr "
        ",sum(trx.dr) as totalDr "
        "from $transactionTableName trx ";

    String whereClause = "where trx.groupId = ? ";
    List<Object?> pars = [filter.groupId];

    if (filter.dateMode == "trxPeriod") {
      whereClause += "and trx.trxPeriod >= ? "
          "and trx.trxPeriod <= ? ";
      pars.add(AppUtils.getTrxPeriodFromDt(filter.sdt));
      pars.add(AppUtils.getTrxPeriodFromDt(filter.edt));
    } else if (filter.dateMode == "trxDt") {
      whereClause += "and trx.trxDt >= ? "
          "and trx.trxDt <= ? ";
      pars.add(filter.sdt.toIso8601String());
      pars.add(filter.edt.toIso8601String());
    }

    String groupBy = "group by trx.groupId, trx.trxPeriod, trx.trxType ";
    String orderBy = "order by trx.trxPeriod ";
    String query = selectQuery + whereClause + groupBy + orderBy;
    var rows = await dbService.read(query, pars);
    var balances = await getBalances(filter);
    var summary = rows.map((e) => GroupSummary.fromJson(e)).toList();
    var openingBalance = balances.first;
    var closingBalance = balances.last;
    summary.insert(0, openingBalance);
    summary.add(closingBalance);
    return summary;
  }

  Future<List<GroupSummary>> getBalances(GroupSummaryFilter filter) async {
    String selectQuery = "select "
        "? as groupId, "
        "? as trxType, "
        "? as trxPeriod, "
        "ifnull(sum(trx.cr), 0) as totalCr, "
        "ifnull(sum(trx.dr), 0) as totalDr "
        "from $transactionTableName trx ";
    String whereClause = "where trx.groupId = ? ";
    String trxPeriodSdt = AppUtils.getTrxPeriodFromDt(filter.sdt);
    String trxPeriodEdt = AppUtils.getTrxPeriodFromDt(filter.edt);
    List<Object?> openingPars = [
      filter.groupId,
      AppConstants.ttOpeningBalance,
      trxPeriodSdt,
      filter.groupId,
      trxPeriodSdt
    ];
    List<Object?> closingPars = [
      filter.groupId,
      AppConstants.ttClosingBalance,
      trxPeriodEdt,
      filter.groupId,
      trxPeriodEdt
    ];
    String openingBalance =
        selectQuery + whereClause + "and trx.trxPeriod < ? ";
    String closingBalance =
        selectQuery + whereClause + "and trx.trxPeriod <= ? ";
    String query = "$openingBalance union $closingBalance";

    var rows = await dbService.read(query, [
      ...openingPars,
      ...closingPars,
    ]);
    var summary = rows.map((e) => GroupSummary.fromJson(e)).toList();
    return summary.reversed.toList();
  }

  Future<GroupTotal> getTotalBalances(GroupTotalFilter filter) async {
    String balanceQuery = "select "
        "sum(trx.cr - trx.dr) as balance "
        "from $transactionTableName trx "
        "where trx.groupId = ? ";
    String memberCountQuery = "select "
        "count(1) as memberCount "
        "from $memberTableName m "
        "where m.groupId = ? ";
    String totalGroupAmountQuery = "select "
        "sum(trx.cr + iif(trx.trxType = '${AppConstants.ttExpenditures}', -1, 1) * trx.dr) as totalSaving "
        "from $transactionTableName trx "
        "where trx.groupId = ? "
        "and (trx.trxType in ${AppConstants.dbCreditFilter} "
        "or trx.trxType in ('${AppConstants.ttExpenditures}' )) ";
    String query = "select ifnull(($balanceQuery), 0) as balance, "
        "ifnull(($memberCountQuery), 0) as memberCount, "
        "ifnull(($totalGroupAmountQuery), 0) as totalSaving, "
        "0 as perMemberShare ";
    var rows = await dbService
        .read(query, [filter.groupId, filter.groupId, filter.groupId]);
    var totals = rows.map((e) => GroupTotal.fromJson(e)).toList();
    var total = totals.isEmpty ? GroupTotal() : totals[0];
    if (total.memberCount != 0) {
      total.perMemberShare = total.totalSaving / total.memberCount;
    }
    return total;
  }

  String getAmountQuery(String trxType, String trxPeriod,
      [String mode = "cr"]) {
    String column = "t.cr";
    if (mode == "dr") {
      column = "t.dr";
    } else if (mode == "both") {
      column = "t.cr - t.dr";
    }
    return "select ifnull(sum($column), 0) "
        "from $transactionTableName t "
        "where t.groupId = m.groupId "
        "and t.memberId = m.id "
        "and t.trxPeriod = '$trxPeriod' "
        "and t.trxType = '$trxType' ";
  }
}
