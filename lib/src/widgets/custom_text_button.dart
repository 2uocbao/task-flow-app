import 'package:taskflow/src/utils/app_export.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(
      {super.key,
      this.decoration,
      this.margin,
      this.onPressed,
      this.buttonStyle,
      this.alignment,
      this.buttonTextStyle,
      this.isDisable,
      this.height,
      this.width,
      required this.text});

  final String text;

  final BoxDecoration? decoration;

  final VoidCallback? onPressed;

  final ButtonStyle? buttonStyle;

  final TextStyle? buttonTextStyle;

  final bool? isDisable;

  final double? height;

  final double? width;

  final EdgeInsets? margin;

  final Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment ?? Alignment.center,
      child: Container(
        height: height ?? 25.h,
        width: width,
        margin: margin,
        decoration: decoration,
        child: ElevatedButton(
          style: buttonStyle,
          onPressed: isDisable ?? false ? null : onPressed ?? () {},
          child: Text(
            text,
            style: buttonTextStyle ?? Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ),
    );
  }
}
