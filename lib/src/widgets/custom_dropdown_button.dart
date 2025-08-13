import 'package:taskflow/src/utils/app_export.dart';

class CustomDropdownButton<T> extends StatelessWidget {
  final List<T> items;

  final T? value;

  final double? width;

  final void Function(T?)? onChanged;

  final void Function()? onTap;

  final TextStyle? textStyle;

  const CustomDropdownButton(
      {super.key,
      required this.items,
      required this.value,
      this.onChanged,
      this.onTap,
      this.width,
      this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 110.w,
      padding: EdgeInsets.symmetric(
        horizontal: 5.h,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        borderRadius: BorderRadiusStyle.circleBorder10,
      ),
      child: DropdownButton<T>(
        isExpanded: true,
        underline: const SizedBox(),
        value: value,
        hint: Text(
          items.first.toString(),
        ),
        onChanged: onChanged,
        onTap: onTap,
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(
              item.toString(),
              style: textStyle,
            ),
          );
        }).toList(),
      ),
    );
  }
}
