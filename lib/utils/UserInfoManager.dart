import 'package:car_repair/base/Config.dart';
import 'package:car_repair/base/FirestoreUtils.dart';
import 'package:car_repair/entity/user_infor_entity.dart';
import 'package:car_repair/generated/json/user_infor_entity_helper.dart';
import 'DBHelp.dart';

class UserInfoManager {
  /**
   * get userinfo from local, if none get it from net and cache it.
   * if isNetFirst is true, then get data from net firest and cache it later.
   */
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
      if(userinfo != null)
        print('!!! get data from relationship ${userinfo.displayName}');
      userinfo != null
          ? cacheUserInfor(userinfo)
          : cacheUserInfor(userinfor);


      return userinfor;
    }
  }

  static refreshSelf(){
    UserInforEntity entity = UserInforEntity();
    entity = userInforEntityFromJson(entity, Config.userInfo.toJson());
    print('!!! self name ${Config.userInfo.displayName}');
    print('!!! self name ${Config.userInfo.photoUrl}');
    cacheUserInfor(entity);
  }

  /**
   * opertaor user relationship,
   * add or remove friend / blacklist, or edit remarkName
   */
  static operatiorUser(UserInforEntity entity,
      {friend: bool, black: bool, remark: String}) {
    if (friend != null) return FireStoreUtils.operatorFriend(entity, friend);
    if (black != null) return FireStoreUtils.operatorBlackList(entity, black);
    if (remark != null) return FireStoreUtils.editUserRemarkName(entity, remark);
  }
}
