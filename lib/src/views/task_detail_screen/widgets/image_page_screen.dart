import 'package:taskflow/src/utils/app_export.dart';

class ImagePageScreen extends StatelessWidget {
  final String imageUrl;

  final Map<String, String> httpHeaders;

  const ImagePageScreen(
      {super.key, required this.imageUrl, required this.httpHeaders});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(
            imageUrl,
            headers: httpHeaders,
          ),
        ),
      ),
    );
  }
}
