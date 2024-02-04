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
    return Card(
      child: ListTile(
        titleAlignment: ListTileTitleAlignment.center,
        title: Text(
          groupMemberDetail.name,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        subtitle: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            CustomAmountChip(
              label: local.lBalance,
              amount: groupMemberDetail.balance,
            ),
            CustomAmountChip(
              label: local.lShare,
              amount: groupMemberDetail.paidShareAmount,
            ),
            CustomAmountChip(
              label: local.lLateFee,
              amount: groupMemberDetail.paidLateFee,
            ),
            CustomAmountChip(
              label: local.lLoan,
              amount: groupMemberDetail.paidLoanAmount,
            ),
            CustomAmountChip(
              label: local.lRmLoan,
              amount: groupMemberDetail.pendingLoanAmount,
            )
          ],
        ),
      ),
    );
  }
}
