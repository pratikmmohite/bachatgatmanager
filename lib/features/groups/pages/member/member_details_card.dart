import 'package:bachat_gat/common/common_index.dart';
import 'package:bachat_gat/locals/app_local_delegate.dart';
import 'package:flutter/material.dart';

import '../../models/models_index.dart';

class MemberDetailsCard extends StatelessWidget {
  final GroupMemberDetails groupMemberDetail;
  const MemberDetailsCard(
    this.groupMemberDetail, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var local = AppLocal.of(context);
    return ListTile(
      titleAlignment: ListTileTitleAlignment.center,
      title: Text(
        groupMemberDetail.name,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
      subtitle: Table(
        children: [
          TableRow(children: [
            CustomAmountChip(
              label: local.lPaidShare,
              amount: groupMemberDetail.paidShareAmount,
            ),
            CustomAmountChip(
              label: local.lPaidInterest,
              amount: groupMemberDetail.paidLateFee,
            ),
          ]),
          TableRow(children: [
            CustomAmountChip(
              label: local.lPaidLoan,
              amount: groupMemberDetail.paidLoanAmount,
            ),
            CustomAmountChip(
              label: local.lRmLoan,
              amount: groupMemberDetail.pendingLoanAmount,
            )
          ])
        ],
      ),
    );
  }
}
