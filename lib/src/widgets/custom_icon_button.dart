import 'package:taskflow/src/utils/app_export.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    this.alignment,
    this.height,
    this.width,
    this.decoration,
    this.padding,
<<<<<<< HEAD
    this.margin,
=======
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
    this.onTap,
    this.child,
  });

  final Alignment? alignment;

  final double? height;

  final double? width;

  final BoxDecoration? decoration;

  final EdgeInsetsGeometry? padding;

<<<<<<< HEAD
  final EdgeInsetsGeometry? margin;

=======
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
  final VoidCallback? onTap;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center, child: iconButtonWidget)
        : iconButtonWidget;
  }

<<<<<<< HEAD
  Widget get iconButtonWidget => Container(
        height: height ?? 25.h,
        width: width ?? 25.w,
        margin: margin,
=======
  Widget get iconButtonWidget => SizedBox(
        height: height ?? 25.h,
        width: width ?? 25.h,
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
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
