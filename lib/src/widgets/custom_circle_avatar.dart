import 'package:taskflow/src/utils/app_export.dart';

class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar(
      {super.key, required this.imagePath, required this.size});

  final String imagePath;

  final double size;

  @override
  Widget build(BuildContext context) {
    if (imagePath.isNotEmpty) {
      return ClipOval(
        child: CustomImageView(
          width: size.sp,
          height: size.sp,
          imagePath: imagePath,
          fit: BoxFit.cover,
        ),
      );
    }
    return CustomImageView(
      width: size.sp,
      height: size.sp,
      fit: BoxFit.cover,
      imagePath: 'assets/images/account.png',
    );
  }
}
