import 'package:cloud_firestore/cloud_firestore.dart';
import 'conf.dart';

/**
 * FireStore 远程数据库.带基础搜索功能.
 * 区分Collection 和 Docoument. 两种连接方式不同.
 * 需要一套 增删改查.
 */
class FireStoreUtils {
  /**********************Collection****************************/
  /**
   * Collection 增
   */
  addCollection(String path) {}

  /**
   * Collection 删
   */
  deleteCollection(String path) {}

  /**
   * Collection 改
   */
  updateCollection(String path) {}

  /**
   * Collection 查
   */
  queryCollection(String path) {}

  /**********************Docoument****************************/

  /**
   * Docoument 增
   */
  addDocoument(String path) {}

  /**
   * Docoument 删
   */
  deleteDocoument(String path) {}

  /**
   * Docoument 改
   */
  updateDocoument(String path) {}

  /**
   * Docoument 查
   */
  queryDocoument(String path) {}
}
