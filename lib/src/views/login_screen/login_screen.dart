import 'package:app_links/app_links.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/utils/token_storage.dart';
import 'package:taskflow/src/views/login_screen/bloc/login_screen_bloc.dart';
import 'package:taskflow/src/views/login_screen/bloc/login_screen_event.dart';
import 'package:taskflow/src/views/login_screen/bloc/login_screen_state.dart';
import 'package:taskflow/src/widgets/custom_text_button.dart';
import 'package:taskflow/src/utils/app_export.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider<LoginScreenBloc>(
      create: (context) => LoginScreenBloc(LoginScreenState()),
      child: const LoginScreen(),
    );
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AppLinks _appLinks;
  final logger = Logger();

  @override
  void initState() {
    super.initState();

    _appLinks = AppLinks();
    startListening();
  }

  void startListening() async {
    _appLinks.uriLinkStream.listen((Uri? uri) {
      handleLink(uri!);
    });
  }

  void handleLink(Uri link) async {
    if (link.path == "/oauth2") {
      final token = link.queryParameters["token"];
      final refresh = link.queryParameters["refresh"];
      if (token != null && refresh != null) {
        await TokenStorage.saveRefresh(refresh);
        await TokenStorage.saveToken(token);
        // ignore: use_build_context_synchronously
        context.read<LoginScreenBloc>().add(FetchUserDetailEvent());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: double.maxFinite,
      height: screenHeight,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/login_image.png',
            height: screenHeight * (1 / 2),
            width: double.maxFinite,
            fit: BoxFit.contain,
          ),
          SizedBox(
            child: Text(
              'title_welcome'.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          SizedBox(
            child: Text(
              textAlign: TextAlign.center,
              'description'.tr(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          SizedBox(
            child: Text(
              textAlign: TextAlign.center,
              'description1'.tr(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          SizedBox(
            height: 100.h,
          ),
          CustomTextButton(
            text: 'lbl_sign_in_by_google'.tr(),
            onPressed: () {
              context.read<LoginScreenBloc>().add(SignInWithGoogle());
              // context.read<LoginScreenBloc>().add(FetchUserDetailEvent());
            },
          ),
        ],
      ),
    );
  }
}
