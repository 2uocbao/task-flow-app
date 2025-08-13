import 'package:easy_localization/easy_localization.dart';
import 'package:intl/date_symbol_data_local.dart';

const String dateTimeFormatPattern = 'dd/MM/yyyy';
// ignore: constant_identifier_names
const String D_M_Y_HH_mm = 'yyyy-MM-dd HH:mm';
// ignore: constant_identifier_names
const String D_M_Y = 'yyyy-MM-dd';

extension DateTimeUtils on DateTime {
  String format({
    String? pattern,
    String? locale,
  }) {
    if (locale != null && locale.isNotEmpty) {
      initializeDateFormatting(locale, null.toString());
    }
    return DateFormat(pattern, locale).format(this);
  }

  // String hasBeen({required String date}) {
  //   final dateTime = DateTime.parse(date);
  //   final now = DateTime.now().toUtc();
  //   final duration = now.difference(dateTime);

  //   if (duration.inDays > 0) {
  //     return '${duration.inDays} ngày';
  //   } else if (duration.inHours > 0) {
  //     return '${duration.inHours.remainder(24)} giờ trước';
  //   } else if (duration.inMinutes.remainder(60) > 0) {
  //     return '${duration.inMinutes.remainder(60)} phút trước';
  //   }
  //   return '${duration.inSeconds.remainder(60)} giây trước';
  // }
}

String formatDate({required String date}) {
  DateTime dateTime = DateTime.parse(date);
  String day = dateTime.day.toString();
  String month = 'Th${dateTime.month}';
  return '$day $month';
}

String formatDateAndTime({required String date}) {
  DateTime dateTime = DateTime.parse(date);
  String day = dateTime.day.toString();
  String month = 'Th${dateTime.month}';
  String time = DateFormat('HH:mm').format(dateTime);
  return '$day $month ${'lbl_at'.tr()} $time';
}

bool isToday(DateTime dateTime) {
  final now = DateTime.now();
  return dateTime.year == now.year &&
      dateTime.month == now.month &&
      dateTime.day == now.day;
}

String time(String date) {
  final now = DateTime.now();
  DateTime dateTime = DateTime.parse(date);
  if (dateTime.year == now.year) {
    if (dateTime.month == now.month) {
      if (dateTime.day == now.day) {
        return "TODAY".tr();
      } else if ((dateTime.day - now.day) == 1) {
        return "lbl_tomorrow".tr();
      } else {
        return "${dateTime.day}-${dateTime.month}";
      }
    } else {
      return "${'lbl_month'.tr()} ${dateTime.month}";
    }
  }
  return "'${'lbl_year'.tr()}' ${dateTime.year}";
}
