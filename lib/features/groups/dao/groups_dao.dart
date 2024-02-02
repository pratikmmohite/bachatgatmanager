import 'package:bachat_gat/common/constants.dart';

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
    String whereClause = "where memberId = ? "
        "and groupId = ? ";
    if (filter.status.isNotEmpty) {
      whereClause += "and status = ? ";
    }
    String query = selectClause + whereClause;
    var rows = await dbService.read(
      query,
      [
        filter.memberId,
        filter.groupId,
        filter.status,
      ],
    );
    var loans = rows.map((e) => Loan.fromJson(e)).toList();
    return loans;
  }

  Future<List<GroupMemberDetails>> getGroupMembersWithBalance(
      MemberBalanceFilter filter) async {
    String paidInstallmentAmount = "(select ifnull(sum(t.cr), 0) "
        "from $transactionTableName t "
        "where t.groupId = m.groupId "
        "and t.memberId = m.id "
        "and t.trxPeriod = ? "
        "and t.trxType = '${AppConstants.ttShare}' "
        ") as paidShareAmount ";
    String balanceAmount = "(select ifnull(sum(t.cr-t.dr), 0) "
        "from $transactionTableName t "
        "where t.groupId = m.groupId "
        "and t.memberId = m.id "
        ") as balance ";
    String paidLoanAmount = "(select ifnull(sum(t.cr), 0) "
        "from $transactionTableName t "
        "where t.groupId = m.groupId "
        "and t.memberId = m.id "
        "and t.trxPeriod = ? "
        "and t.trxType = '${AppConstants.ttLoan}' "
        ") as paidLoanAmount ";
    String paidPenaltyAmount = "(select ifnull(sum(t.cr), 0) "
        "from $transactionTableName t "
        "where t.groupId = m.groupId "
        "and t.memberId = m.id "
        "and t.trxPeriod = ? "
        "and t.trxType = '${AppConstants.ttLateFee}' "
        ") as paidLateFee ";

    String pendingLoanAmount = "(select iif(sum(l.remainingLoanAmount)) "
        "from $loanTableName l "
        "where l.groupId = m.groupId "
        "and l.memberId = m.id "
        ") as pendingLoanAmount ";

    String query = "select m.id "
        ",m.name "
        ",m.groupId "
        ",$paidInstallmentAmount "
        ",$paidLoanAmount "
        ",$paidPenaltyAmount "
        ",$balanceAmount "
        ",$pendingLoanAmount "
        "from $memberTableName m "
        "where m.groupId = ? ";

    var rows = await dbService.read(query,
        [filter.trxPeriod, filter.trxPeriod, filter.trxPeriod, filter.groupId]);
    var members = rows.map((e) => GroupMemberDetails.fromJson(e)).toList();
    return members;
  }
}
