import 'package:taskflow/src/utils/app_export.dart';

class BorderRadiusStyle {
  static BorderRadius get circleBorder5 => BorderRadius.circular(5.r);

  static BorderRadius get circleBorder10 => BorderRadius.circular(10.r);

  static BorderRadius get circleBorder20 => BorderRadius.circular(20.r);

  static BorderRadius get circleBorder30 => BorderRadius.circular(30.r);

  static BorderRadius get customBorderT5 => BorderRadius.only(
      topLeft: Radius.circular(5.r), topRight: Radius.circular(5.r));
}
