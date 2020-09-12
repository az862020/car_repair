import 'package:car_repair/base/Config.dart';
import 'package:car_repair/base/Events.dart';
import 'package:car_repair/base/FirestoreUtils.dart';
import 'package:car_repair/entity/user_infor_entity.dart';
import 'package:car_repair/generated/json/user_infor_entity_helper.dart';
import 'DBHelp.dart';

class UserInfoManager {
  /// get userinfo from local, if none get it from net and cache it.

  /// if isNetFirst is true, then get data from net firest and cache it later.

  static Future<UserInforEntity> getUserInfo(String uid,
      {bool isNetFirst}) async {
    var localUser = await getUserInfor(uid);
    //has local cache and isnot net first.
    if (localUser != null && !(isNetFirst ?? false)) {
      print('!!! get data from local ${localUser.displayName}');
      return localUser;
    } else {
      var doc = await FireStoreUtils.queryUserinfo(uid);
      print('!!! get data from net ${doc.id}');
      var userinfor = UserInforEntity();
      userInforEntityFromJson(userinfor, doc.data());
      userinfor.uid = doc.id;

      var userinfo = await FireStoreUtils.getUserInfoRelation(uid);
      if (userinfo != null)
        print('!!! get data from relationship ${userinfo.displayName}');
      userinfo != null ? cacheUserInfor(userinfo) : cacheUserInfor(userinfor);

      return userinfor;
    }
  }

  static refreshSelf() {
    UserInforEntity entity = UserInforEntity();
    entity = userInforEntityFromJson(entity, Config.userInfo.toJson());
    print('!!! self name ${Config.userInfo.displayName}');
    print('!!! self name ${Config.userInfo.photoUrl}');
    cacheUserInfor(entity);
  }

  /// opertaor user relationship,
  /// add or remove friend / blacklist, or edit remarkName
  static Future<void> operatiorUser(UserInforEntity entity,
      {friend: bool, black: bool, remark: String, event: true}) async {
    if (friend != null) {
      await FireStoreUtils.operatorFriend(entity, friend);
      entity.isFriend = friend ? 1 : 0;
      await cacheUserInfor(entity);
      if (event) eventBus.fire(FriendEvent());
      return;
    }
    if (black != null) {
      await FireStoreUtils.operatorBlackList(entity, black);
      entity.isBlack = black ? 1 : 0;
      await cacheUserInfor(entity);
      if (event) eventBus.fire(BlackListEvent());
      return;
    }
    if (remark != null) {
      await FireStoreUtils.editUserRemarkName(entity, remark);
      entity.remarkName = remark;
      await cacheUserInfor(entity);
      if (event) eventBus.fire(RemarkEvent());
      return;
    }
  }

  /// get friends list from local
  static Future<List<UserInforEntity>> getFriendList() async {
    var friends = await queryFriends();
    return friends;
  }

  /// get friends list from local
  static Future<List<UserInforEntity>> getBlackList() async {
    var blacklist = await queryBlackList();
    return blacklist;
  }

  /// get relation ship list from net, and cache it.
  static Future<bool> RefreshShip() async {
    try {
      var shiplist = await FireStoreUtils.getFriendList();
      for (var user in shiplist) {
        cacheUserInfor(user);
      }
      print('!!! ship list cache finish.');
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
