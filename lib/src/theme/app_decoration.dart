import 'package:taskflow/src/utils/app_export.dart';

class BorderRadiusStyle {
  static BorderRadius get circleBorder5 => BorderRadius.circular(5.h);

  static BorderRadius get circleBorder10 => BorderRadius.circular(10.h);

  static BorderRadius get circleBorder20 => BorderRadius.circular(20.h);

  static BorderRadius get circleBorder30 => BorderRadius.circular(30.h);

  static BorderRadius get customBorderT5 => BorderRadius.only(
      topLeft: Radius.circular(5.h), topRight: Radius.circular(5.h));
}
