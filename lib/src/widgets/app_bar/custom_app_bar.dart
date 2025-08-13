import 'package:taskflow/src/utils/app_export.dart';

enum Style { bgFillOnPrimaryContainer }

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key,
      this.height,
      this.shape,
      this.styleType,
      this.leadingWidth,
      this.leading,
      this.title,
      this.centerTitle,
      this.actions});

  final double? height;

  final ShapeBorder? shape;

  final Style? styleType;

  final double? leadingWidth;

  final Widget? leading;

  final Widget? title;

  final bool? centerTitle;

  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      shape: shape,
      toolbarHeight: height ?? 30.h,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      flexibleSpace: _getStyle(),
      leadingWidth: leadingWidth ?? 30.h,
      leading: leading,
      title: title,
      titleSpacing: 0,
      centerTitle: centerTitle ?? false,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size(double.maxFinite, 30.h);

  Container? _getStyle() {
    switch (styleType) {
      case Style.bgFillOnPrimaryContainer:
        return Container(
          height: height ?? 30.h,
          width: double.maxFinite,
          decoration: const BoxDecoration(
              // color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
              ),
        );
      default:
        return null;
    }
  }
}
