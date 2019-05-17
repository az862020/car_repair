import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

/**
 * 这个用于存储shardpreferences的key值.
 */
class Config {
  static String RemberSet = 'rember'; //是否记住密码
  static String UsernameSet = 'rember_username'; //记住的账号
  static String PasswordSet = 'rember_password'; //记住的密码

  static String testSettings = 'testSettings'; //测试用的.
  static String testSettings2 = 'testSettings2'; //测试用的.

  static String AppDir = ''; //应用外部存储路径.
  static String AppDirFile = ''; //应用外部存储路径-文件文件夹.
  static String AppDirCache = ''; //应用外部存储路径-缓存文件夹.


  static FirebaseUser user;

  static FirebaseStorage storage;

  /**
   * 初始化外部文件路径.
   * todo 只针对安卓, 虽然可能之后就得改掉. 因为iOS没有.
   */
  initAppDir() {
    getExternalStorageDirectory().then((dir) {
      PackageInfo.fromPlatform().then((packageinfo) {
        Config.AppDir = '${dir.path}/Android/data/${packageinfo.packageName}';
        checkFileExist('${Config.AppDir}/files').then((dir) {
          Config.AppDirFile = dir;
        });
        checkFileExist('${Config.AppDir}/cache').then((dir) {
          Config.AppDirCache = dir;
        });
      });
    });
    print('${Config.AppDir}');
  }

  Future<String> checkFileExist(String dir) async {
    bool exist = await Directory(dir).exists();
    if (!exist) {
      Directory(dir).create(recursive: true);
    } else {}
    dir = '$dir/';
    print('!!!! $dir');
    return dir;
  }



  initFirebaseStorage() async{
    final FirebaseApp app = await FirebaseApp.configure(
      name: 'CarRepair',
      options: FirebaseOptions(
        googleAppID: Platform.isIOS
            ? '1:159623150305:ios:4a213ef3dbd8997b'
            : '1:789785197992:android:2a1a64a971672b1f',
        gcmSenderID: '789785197992',
        apiKey: 'AIzaSyBL6o9UXLGTj5fdNcIhYvVc2qnfp58YmuQ',
        projectID: 'carrepair-16710',
        storageBucket: 'gs://carrepair-16710.appspot.com/',
      ),
    );
    storage = await FirebaseStorage(
        app: app, storageBucket: 'gs://carrepair-16710.appspot.com/');
    print('!!! init storage ${storage.storageBucket}');
    print('!!! init storage2 ${FirebaseStorage.instance.storageBucket}');
    print('!!! ${storage.ref().child('userinfo/avatar/image_crop_dog.jpg').getName()}');
  }
}
