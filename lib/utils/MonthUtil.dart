import 'package:common_utils/common_utils.dart';

class MonthUtil {
  /**
   * String : yyyy-mm
   */
  static String getCurrentData({String date}) {
    if (date == null)
      return DateUtil.getDateStrByDateTime(DateTime.now(),
          format: DateFormat.YEAR_MONTH);
    else {
      List<String> time = date.split("-");
      int month = int.parse(time[1]) - 1;
      int year = int.parse(time[0]) - 1;
      if (month > 0) {
        return '${time[0]}-' + '${month < 10 ? '0$month':'$month' }';
      } else {
        return date = '$year-12';
      }
    }
  }


}
