/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:bachat_gat/common/common_index.dart';
import 'package:bachat_gat/locals/app_local_delegate.dart';
import 'package:flutter/material.dart';

import '../../models/models_index.dart';

class MemberDetailsCard extends StatelessWidget {
  final GroupMemberDetails groupMemberDetail;
  final DateTime trxPeriodDt;
  const MemberDetailsCard({
    super.key,
    required this.groupMemberDetail,
    required this.trxPeriodDt,
  });

  @override
  Widget build(BuildContext context) {
    var local = AppLocal.of(context);
    return ListTile(
      titleAlignment: ListTileTitleAlignment.center,
      title: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            groupMemberDetail.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Text(AppUtils.getTrxPeriodFromDt(trxPeriodDt))
        ],
      ),
      subtitle: Table(
        children: [
          TableRow(
            children: [
              CustomAmountChip(
                label: local.lPaidShare,
                amount: groupMemberDetail.paidShareAmount,
              ),
              CustomAmountChip(
                label: local.lPaidLateFee,
                amount: groupMemberDetail.paidLateFee,
              ),
            ],
          ),
          TableRow(
            children: [
              CustomAmountChip(
                label: local.lPaidLoan,
                amount: groupMemberDetail.paidLoanAmount,
              ),
              CustomAmountChip(
                label: local.lPaidInterest,
                amount: groupMemberDetail.paidLoanInterestAmount,
              )
            ],
          ),
          TableRow(
            children: [
              CustomAmountChip(
                label: local.lGivenLoan,
                amount: groupMemberDetail.lendLoan,
              ),
              CustomAmountChip(
                label: local.lRmLoan,
                amount: groupMemberDetail.pendingLoanAmount,
              )
            ],
          ),
        ],
      ),
    );
  }
}
