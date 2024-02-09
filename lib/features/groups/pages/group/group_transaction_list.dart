import 'package:bachat_gat/common/common_index.dart';
import 'package:bachat_gat/features/groups/pages/transaction/add_group_transaction.dart';
import 'package:flutter/material.dart';

import '../../dao/dao_index.dart';
import '../../models/models_index.dart';

class GroupTransactionList extends StatefulWidget {
  final Group group;
  const GroupTransactionList({super.key, required this.group});

  @override
  State<GroupTransactionList> createState() => _GroupTransactionListState();
}

class _GroupTransactionListState extends State<GroupTransactionList> {
  late Group group;
  List<Transaction> transactions = [];
  late GroupsDao groupDao;
  bool isLoading = false;
  double totalCr = 0;
  double totalDr = 0;

  Future<void> getTransactions() async {
    transactions = [];
    setState(() {
      isLoading = true;
    });
    try {
      transactions = await groupDao.getTransactions(group.id, "");
      calculateTotals();
    } catch (e) {
      AppUtils.toast(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  void calculateTotals() {
    totalCr = 0;
    totalDr = 0;
    for (var trx in transactions) {
      totalCr += trx.cr;
      totalDr += trx.cr;
    }
  }

  @override
  void initState() {
    groupDao = GroupsDao();
    group = widget.group;
    getTransactions();
    super.initState();
  }

  Future<void> deleteTransaction(Transaction trx) async {
    try {
      await groupDao.deleteTransaction(trx);
      getTransactions();
      AppUtils.toast(context, "Transaction deleted successfully");
    } catch (e) {
      AppUtils.toast(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Transactions"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(group.name),
              const Divider(),
            ],
          ),
        ),
      ),
      bottomSheet: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Total"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Credit"),
                Text(totalCr.toStringAsFixed(2))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [const Text("Debit"), Text(totalDr.toStringAsFixed(2))],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await AppUtils.navigateTo(context, AddGroupTransaction(group: group));
          getTransactions();
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await getTransactions();
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
                      DataCell(Text(
                        trx.note,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15),
                      )),
                      DataCell(Text(AppUtils.getHumanReadableDt(trx.trxDt))),
                      DataCell(
                        CustomDeleteIcon<Transaction>(
                          item: trx,
                          content:
                              Text("Trx: ${trx.trxType} \nAmount ${trx.cr}"),
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
