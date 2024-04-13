import 'package:bachat_gat/features/groups/models/models_index.dart';
import 'package:flutter/material.dart';

import '../../../../common/common_index.dart';
import '../../dao/dao_index.dart';

class MemberTransactionsList extends StatefulWidget {
  final Group group;
  final GroupMemberDetails groupMemberDetails;
  final DateTime trxPeriodDt;
  const MemberTransactionsList(this.group,
      {super.key, required this.groupMemberDetails, required this.trxPeriodDt});

  @override
  State<MemberTransactionsList> createState() => _MemberTransactionsListState();
}

class _MemberTransactionsListState extends State<MemberTransactionsList> {
  late Group group;
  late DateTime trxPeriodDt;
  late GroupMemberDetails groupMemberDetail;
  List<Transaction> transactions = [];
  late GroupsDao groupDao;
  bool isLoading = false;
  String viewMode = "table";

  Future<void> getMemberTransactions() async {
    transactions = [];
    setState(() {
      isLoading = true;
    });
    try {
      transactions = await groupDao.getTransactions(
          groupMemberDetail.groupId, groupMemberDetail.memberId);
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
    groupMemberDetail = widget.groupMemberDetails;
    trxPeriodDt = widget.trxPeriodDt;
    group = widget.group;
    getMemberTransactions();
    super.initState();
  }

  Future<void> deleteTransaction(Transaction trx) async {
    try {
      await groupDao.deleteTransaction(trx);
      getMemberTransactions();
      AppUtils.toast(context, "Transaction deleted successfully");
    } catch (e) {
      AppUtils.toast(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Member Transactions"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(groupMemberDetail.name),
              const Divider(),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await getMemberTransactions();
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              rows: transactions.map(
                (trx) {
                  var cr = trx.cr;
                  var dr = trx.dr;

                  return DataRow(
                    cells: [
                      DataCell(Text(trx.trxPeriod)),
                      DataCell(Text(
                        trx.trxType,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15),
                      )),
                      DataCell(
                        Text(
                          cr.toStringAsFixed(2),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          dr.toStringAsFixed(2),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          trx.note,
                        ),
                      ),
                      DataCell(Text(AppUtils.getHumanReadableDt(trx.trxDt))),
                      DataCell(
                        CustomDeleteIcon<Transaction>(
                          item: trx,
                          content: Table(
                            children: [
                              TableRow(
                                children: [
                                  const TableCell(
                                    child: Text("Transaction Date:"),
                                  ),
                                  TableCell(
                                    child: Text(trx.trxPeriod),
                                  )
                                ],
                              ),
                              TableRow(
                                children: [
                                  const TableCell(
                                    child: Text("Transaction Type:"),
                                  ),
                                  TableCell(
                                    child: Text(trx.trxType),
                                  )
                                ],
                              ),
                              TableRow(
                                children: [
                                  const TableCell(
                                    child: Text("Amount"),
                                  ),
                                  TableCell(
                                    child:
                                        Text("${trx.cr > 0 ? trx.cr : trx.dr}"),
                                  )
                                ],
                              ),
                            ],
                          ),
                          onAccept: (t) {
                            deleteTransaction(t);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ).toList(),
              columns: const [
                DataColumn(
                  label: Text("Month"),
                ),
                DataColumn(
                  label: Text("Type"),
                ),
                DataColumn(
                  label: Text("Credit"),
                ),
                DataColumn(
                  label: Text("Debit"),
                ),
                DataColumn(
                  label: Text("Note"),
                ),
                DataColumn(
                  label: Text("Added On"),
                ),
                DataColumn(
                  label: Text("Action"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
