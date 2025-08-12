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
<<<<<<< HEAD
          fit: BoxFit.fill,
=======
          fit: BoxFit.cover,
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
        ),
      );
    }
    return CustomImageView(
      width: size.sp,
      height: size.sp,
<<<<<<< HEAD
      fit: BoxFit.contain,
=======
      fit: BoxFit.cover,
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
      imagePath: 'assets/images/account.png',
    );
  }
}
