import 'package:bachat_gat/common/common_index.dart';

import '../../dao/dao_index.dart';
import '../../models/models_index.dart';

class GroupMemberDetailsService {
  static Future<List<GroupMemberDetails>> getGroupMemberDetails(
      {required Group group, required DateTime trxPeriodDt}) async {
    List<GroupMemberDetails> groupMemberDetails = [];
    GroupsDao groupDao = GroupsDao();

    var filter =
        MemberBalanceFilter(group.id, AppUtils.getTrxPeriodFromDt(trxPeriodDt));

    try {
      groupMemberDetails = await groupDao.getGroupMembersWithBalance(filter);
    } catch (e) {
      // Handle error appropriately, such as logging or displaying an error message
      print('Error fetching group member details: $e');
    }

    return groupMemberDetails;
  }
}
