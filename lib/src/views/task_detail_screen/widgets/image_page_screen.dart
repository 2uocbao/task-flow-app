import 'package:taskflow/src/utils/app_export.dart';

class ImagePageScreen extends StatelessWidget {
  final String imageUrl;

<<<<<<< HEAD
  final Map<String, String> httpHeaders;

  const ImagePageScreen(
      {super.key, required this.imageUrl, required this.httpHeaders});
=======
  const ImagePageScreen({super.key, required this.imageUrl});
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Center(
        child: InteractiveViewer(
<<<<<<< HEAD
          child: Image.network(
            imageUrl,
            headers: httpHeaders,
          ),
=======
          child: Image.network(imageUrl),
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
        ),
      ),
    );
  }
}
