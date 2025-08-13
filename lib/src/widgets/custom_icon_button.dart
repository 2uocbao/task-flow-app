import 'package:taskflow/src/utils/app_export.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    this.alignment,
    this.height,
    this.width,
    this.decoration,
    this.padding,
    this.margin,
    this.onTap,
    this.child,
  });

  final Alignment? alignment;

  final double? height;

  final double? width;

  final BoxDecoration? decoration;

  final EdgeInsetsGeometry? padding;

  final EdgeInsetsGeometry? margin;

  final VoidCallback? onTap;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center, child: iconButtonWidget)
        : iconButtonWidget;
  }

  Widget get iconButtonWidget => Container(
        height: height ?? 25.h,
        width: width ?? 25.w,
        margin: margin,
        child: DecoratedBox(
          decoration: decoration ?? const BoxDecoration(),
          child: IconButton(
            padding: padding ?? EdgeInsets.zero,
            onPressed: onTap,
            icon: child ?? Container(),
          ),
        ),
      );
}
