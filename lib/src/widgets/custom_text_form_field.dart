import 'package:taskflow/src/utils/app_export.dart';

<<<<<<< HEAD
=======
extension TextFormFieldStyleHelper on CustomTextFormField {
  static OutlineInputBorder get fillOnPrimaryContainer =>
      const OutlineInputBorder(
        borderSide: BorderSide.none,
      );
  static OutlineInputBorder get fillBlack => OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            15.h,
          ),
          topRight: Radius.circular(
            15.h,
          ),
          bottomLeft: Radius.circular(
            15.h,
          ),
          bottomRight: Radius.circular(
            15.h,
          ),
        ),
        borderSide: BorderSide.none,
      );

  static OutlineInputBorder get fillPrimary => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.h),
        borderSide: BorderSide.none,
      );
}

>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
      this.alignment,
      this.width,
      this.boxDecoration,
      this.scrollPadding,
      this.controller,
      this.focusNode,
      this.autofocus = false,
      this.textStyle,
      this.obscureText = false,
      this.readOnly = false,
      this.onTap,
      this.textInputAction = TextInputAction.next,
      this.textInputType = TextInputType.text,
      this.maxLines,
      this.hintText,
      this.hintStyle,
      this.prefix,
      this.prefixConstraints,
      this.suffix,
      this.suffixConstraints,
      this.contentPadding,
      this.borderDecoration,
      this.fillColor,
      this.filled = true,
      this.onChange,
<<<<<<< HEAD
      this.validator,
      this.onFieldSubmitted});
=======
      this.validator});
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7

  final Alignment? alignment;

  final double? width;

  final BoxDecoration? boxDecoration;

  final TextEditingController? scrollPadding;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool? autofocus;

  final TextStyle? textStyle;

  final bool? obscureText;

  final bool? readOnly;

  final VoidCallback? onTap;

  final TextInputAction? textInputAction;

  final TextInputType? textInputType;

  final int? maxLines;

  final String? hintText;

  final TextStyle? hintStyle;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final Widget? suffix;

  final BoxConstraints? suffixConstraints;

  final EdgeInsets? contentPadding;

  final InputBorder? borderDecoration;

  final Color? fillColor;

  final bool? filled;

  final FormFieldValidator<String>? validator;

  final Function(String)? onChange;

<<<<<<< HEAD
  final Function(String)? onFieldSubmitted;

=======
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: textFormFieldWidget(context))
        : textFormFieldWidget(context);
  }

  Widget textFormFieldWidget(BuildContext context) => Container(
        width: width ?? double.maxFinite,
        decoration: boxDecoration,
        child: TextFormField(
          scrollPadding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          controller: controller,
          focusNode: focusNode,
          onTapOutside: (event) {
            if (focusNode != null) {
              focusNode?.unfocus();
            } else {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
<<<<<<< HEAD
          onFieldSubmitted: onFieldSubmitted,
=======
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
          autofocus: autofocus!,
          style: textStyle ?? Theme.of(context).textTheme.bodyMedium,
          obscureText: obscureText!,
          readOnly: readOnly!,
          onTap: () {
            onTap?.call();
          },
          textInputAction: textInputAction,
          keyboardType: textInputType,
<<<<<<< HEAD
          maxLines: maxLines,
=======
          maxLines: null,
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
          minLines: 1,
          decoration: InputDecoration(
            hintText: hintText ?? "",
            hintStyle: hintStyle ?? Theme.of(context).textTheme.bodySmall,
            prefixIcon: prefix,
            prefixIconConstraints: prefixConstraints,
            suffixIcon: suffix,
            suffixIconConstraints: suffixConstraints,
            isDense: true,
            contentPadding:
<<<<<<< HEAD
                contentPadding ?? EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 5.h),
=======
                contentPadding ?? EdgeInsets.fromLTRB(5.h, 5.h, 5.h, 5.h),
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
            fillColor: fillColor ?? Theme.of(context).colorScheme.surface,
            filled: filled,
            border: borderDecoration ??
                OutlineInputBorder(
<<<<<<< HEAD
                  borderRadius: BorderRadiusStyle.circleBorder10,
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface,
                    width: 1.w,
                  ),
                ),
            focusedBorder: borderDecoration ??
                OutlineInputBorder(
                  borderRadius: BorderRadiusStyle.circleBorder10,
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface,
                    // width: 1.w,
                  ),
                ),
=======
                  borderRadius: BorderRadius.circular(10.h),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface,
                    width: 1,
                  ),
                ),
            focusedBorder: (borderDecoration ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.h),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface,
                    width: 1,
                  ),
                )),
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
          ),
          onChanged: onChange,
          validator: validator,
        ),
      );
}
