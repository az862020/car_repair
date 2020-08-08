class UserInforEntity {
  String uid;
  String displayName;
  String remarkName;
  String photoUrl;
  bool isFriend;
  bool isBlack;

  UserInforEntity(this.uid, this.displayName, this.photoUrl);

  Map<String, dynamic> toMap() {
    var map = {
      'uid': uid,
      'displayName': displayName,
      'isFriend': isFriend ?? false,
      'isBlack': isBlack ?? false,
    };
    if (remarkName != null) map['remarkName'] = remarkName;
    if (photoUrl != null) map['photoUrl'] = photoUrl;

    return map;
  }

  UserInforEntity.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    displayName = map['displayName'];
    if (map.containsKey('remarkName')) remarkName = map['remarkName'];
    if (map.containsKey('photoUrl')) photoUrl = map['photoUrl'];
    isFriend = map.containsKey('isFriend') ? false : true;
    isBlack = map.containsKey('isBlack') ? false : true;
  }
}
