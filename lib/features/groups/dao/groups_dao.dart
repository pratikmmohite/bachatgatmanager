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

  Future<int> addTransaction(Transaction trx) async {
    var row = await dbService.insert(transactionTableName, trx.toJson());
    if (trx.trxType == AppConstants.ttLoan) {
      updateLoanPaid(Loan.withPayment(
        trx.sourceId,
        paidLoanAmount: trx.cr,
      ));
    }
    if (trx.trxType == AppConstants.ttLoanInterest) {
      updateLoanPaid(Loan.withPayment(
        trx.sourceId,
        paidInterestAmount: trx.cr,
      ));
    }
    return row;
  }

  Future<int> deleteTransaction(Transaction trx) async {
    var row = await dbService.delete(
      transactionTableName,
      where: "id = ?",
      whereArgs: [trx.id],
    );
    return row;
  }

  Future<int> addLoan(Loan loan) async {
    var row = await dbService.insert(loanTableName, loan.toJson());
    var trxPeriod = AppUtils.getTrxPeriodFromDt(loan.loanDate);
    var trx = Transaction(
      memberId: loan.memberId,
      groupId: loan.groupId,
      trxType: AppConstants.tmLoan,
      trxPeriod: trxPeriod,
      cr: 0,
      dr: loan.loanAmount,
      sourceType: AppConstants.sLoan,
      sourceId: loan.addedBy,
      addedBy: loan.addedBy,
      note: loan.note,
    );
    addTransaction(trx);
    return row;
  }

  Future<int> updateLoanPaid(Loan loan) async {
    String updateQuery = "update loans set "
        "paidLoanAmount = paidLoanAmount + ?, "
        "paidInterestAmount = paidInterestAmount + ? "
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
        .delete(memberTableName, where: "id = ?", whereArgs: [member.id]);
    return row;
  }

  Future<List<GroupMember>> getMembers() async {
    var rows = await dbService.read("select * from $memberTableName");
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

    String pendingLoanAmount =
        "(select ifnull(sum(l.loanAmount - l.paidLoanAmount), 0) "
        "from $loanTableName l "
        "where l.groupId = m.groupId "
        "and l.memberId = m.id "
        ") as pendingLoanAmount ";

    String selectQuery = "select m.name "
        ",m.groupId "
        ",m.id as memberId "
        ",$paidShareAmount "
        ",$paidLoanAmount "
        ",$paidLateFee "
        ",$paidLoanInterestAmount "
        ",$paidOtherAmount "
        ",$balanceAmount "
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

  String getAmountQuery(String trxType, String trxPeriod) {
    return "select ifnull(sum(t.cr), 0) "
        "from $transactionTableName t "
        "where t.groupId = m.groupId "
        "and t.memberId = m.id "
        "and t.trxPeriod = '$trxPeriod' "
        "and t.trxType = '$trxType' ";
  }
}
