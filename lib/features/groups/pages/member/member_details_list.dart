import 'package:bachat_gat/common/common_index.dart';
import 'package:flutter/material.dart';

import '../../dao/dao_index.dart';
import '../../models/models_index.dart';
import '../transaction/add_loan_page.dart';
import '../transaction/add_member_transaction.dart';
import 'member_loan_list.dart';

class MemberDetailsList extends StatefulWidget {
  final String trxPeriod;
  final Group group;
  const MemberDetailsList({
    super.key,
    required this.trxPeriod,
    required this.group,
  });

  @override
  State<MemberDetailsList> createState() => _MemberDetailsListState();
}

class _MemberDetailsListState extends State<MemberDetailsList> {
  late Group group;
  late String trxPeriod;
  List<GroupMemberDetails> groupMemberDetails = [];
  late GroupsDao groupDao;
  bool isLoading = false;

  Future<void> getGroupMembers() async {
    groupMemberDetails = [];
    var filter = MemberBalanceFilter(group.id, trxPeriod);
    setState(() {
      isLoading = true;
    });
    try {
      groupMemberDetails = await groupDao.getGroupMembersWithBalance(filter);
    } catch (e) {
      AppUtils.toast(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    groupDao = GroupsDao();
    group = widget.group;
    trxPeriod = widget.trxPeriod;
    getGroupMembers();
    super.initState();
  }

  Future<void> handleAddTrxClick(GroupMemberDetails memberDetails) async {
    await AppUtils.navigateTo(
      context,
      AddMemberTransaction(
        groupMemberDetail: memberDetails,
        trxPeriod: trxPeriod,
        group: group,
        mode: AppConstants.tmPayment,
      ),
    );
    getGroupMembers();
  }

  Future<void> handleAddLoanTrxClick(GroupMemberDetails memberDetails) async {
    await AppUtils.navigateTo(
      context,
      AddMemberTransaction(
        groupMemberDetail: memberDetails,
        trxPeriod: trxPeriod,
        group: group,
        mode: AppConstants.tmLoan,
      ),
    );
    getGroupMembers();
  }

  Future<void> handleAddLoanClick(GroupMemberDetails memberDetails) async {
    await AppUtils.navigateTo(
      context,
      AddLoanPage(
        groupMemberDetail: memberDetails,
        trxPeriod: trxPeriod,
        group: group,
      ),
    );
    getGroupMembers();
  }

  DataCell buildCellS(String label, [GestureTapCallback? onTap]) {
    return DataCell(
      Text(label),
      onTap: onTap,
    );
  }

  DataCell buildCellI(Widget icon, [GestureTapCallback? onTap]) {
    return DataCell(
      icon,
      onTap: onTap,
    );
  }

  DataCell buildCellD(double label, [GestureTapCallback? onTap]) {
    return DataCell(
      Text("₹${label.toInt()}"),
      onTap: onTap,
    );
  }

  Widget buildDetailsTable() {
    List<String> columns = [
      "Member",
      "Share(+)",
      "Remaining Loan(-)",
      "Loan(+)",
      "Interest(+)",
      "Penalty(+)",
      "Others(+)",
      "Total",
      "Actions",
    ];
    List<DataRow> rows = groupMemberDetails
        .map(
          (m) => DataRow(
            cells: [
              buildCellS(m.name, () => handleAddTrxClick(m)),
              buildCellD(m.paidShareAmount),
              buildCellD(m.pendingLoanAmount, () => handleShowLoanClick(m)),
              buildCellD(m.paidLoanAmount, () => handleAddLoanTrxClick(m)),
              buildCellD(m.paidLoanInterestAmount),
              buildCellD(m.paidLateFee),
              buildCellD(m.paidOtherAmount),
              buildCellD(m.balance),
              buildCellI(
                Row(
                  children: [
                    IconButton(
                      onPressed: () => handleAddTrxClick(m),
                      icon: const Icon(Icons.add_box_outlined),
                      tooltip: "Add Sare",
                    ),
                    IconButton(
                      onPressed: () => handleAddLoanTrxClick(m),
                      icon: const Icon(Icons.add_shopping_cart),
                      tooltip: "Add Loan",
                    ),
                    IconButton(
                      onPressed: () => handleShowLoanClick(m),
                      icon: const Icon(Icons.account_balance_outlined),
                      tooltip: "Show Loans",
                    )
                  ],
                ),
              ),
            ],
          ),
        )
        .toList();
    var summary = getSummaryRow();
    rows.add(summary);
    return DataTable(
        columns: columns
            .map(
              (e) => DataColumn(
                label: Text(
                  e,
                ),
              ),
            )
            .toList(),
        rows: rows);
  }

  DataRow getSummaryRow() {
    double totalBalance = 0;
    double totalPaidShareAmount = 0;
    double totalPaidLoanAmount = 0;
    double totalPaidLateFee = 0;
    double totalPendingLoanAmount = 0;
    double totalPaidLoanInterestAmount = 0;
    double totalPaidOtherAmount = 0;
    for (var m in groupMemberDetails) {
      totalBalance += m.balance;
      totalPaidShareAmount += m.paidShareAmount;
      totalPaidLoanAmount += m.paidLoanAmount;
      totalPaidLateFee += m.paidLateFee;
      totalPendingLoanAmount += m.pendingLoanAmount;
      totalPaidLoanInterestAmount += m.paidLoanInterestAmount;
      totalPaidOtherAmount += m.paidOtherAmount;
    }

    return DataRow(cells: [
      buildCellS("Total"),
      buildCellD(totalPaidShareAmount),
      buildCellD(totalPendingLoanAmount),
      buildCellD(totalPaidLoanAmount),
      buildCellD(totalPaidLoanInterestAmount),
      buildCellD(totalPaidLateFee),
      buildCellD(totalPaidOtherAmount),
      buildCellD(totalBalance),
      buildCellS(""),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            onRefresh: () async {
              await getGroupMembers();
            },
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: buildDetailsTable(),
            ),
          );
  }

  handleShowLoanClick(GroupMemberDetails m) async {
    await AppUtils.navigateTo(
        context, MembersLoanList(group, groupMemberDetails: m));
    getGroupMembers();
  }
}
