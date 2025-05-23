import 'package:taskflow/src/utils/app_export.dart';

class ImagePageScreen extends StatelessWidget {
  final String imageUrl;

  const ImagePageScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        foregroundColor: Colors.white,
        // actions: [
        //   Transform.rotate(
        //     angle: 90 * 3.1415926535 / 180,
        //     child: CustomIconButton(
        //       padding: EdgeInsets.only(top: 10.w),
        //       child: Icon(
        //         Icons.keyboard_control_sharp,
        //         size: 25.sp,
        //         color: Colors.white,
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}
