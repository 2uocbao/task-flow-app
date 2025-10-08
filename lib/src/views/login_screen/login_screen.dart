import 'package:app_links/app_links.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/utils/token_storage.dart';
import 'package:taskflow/src/views/login_screen/bloc/login_screen_bloc.dart';
import 'package:taskflow/src/views/login_screen/bloc/login_screen_event.dart';
import 'package:taskflow/src/views/login_screen/bloc/login_screen_state.dart';
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

  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    startListening();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
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
    return BlocBuilder<LoginScreenBloc, LoginScreenState>(
      builder: (context, state) {
        if (state is SignInFailure) {
          NavigatorService.showSnackBar('lbl_error'.tr());
          context.read<LoginScreenBloc>().add(ResetState());
        }
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SafeArea(
            child: SingleChildScrollView(
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
                  SizedBox(height: 5.h),
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
                  _buildUsernameAndPasswordInput(context),
                  SizedBox(height: 20.h),
                  CustomTextButton(
                    buttonStyle: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.onSurface)),
                    buttonTextStyle: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                            color: Theme.of(context).colorScheme.surface),
                    text: 'lbl_sign_in_by_google'.tr(),
                    onPressed: () {
                      context.read<LoginScreenBloc>().add(SignInWithGoogle());
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUsernameAndPasswordInput(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: Column(
        children: [
          SizedBox(height: 10.h),
          CustomTextFormField(
            maxLines: 1,
            controller: _usernameController,
            hintText: 'Username',
            contentPadding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 15.h),
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 10.h),
          CustomTextButton(
            text: 'Login',
            buttonTextStyle: Theme.of(context).textTheme.headlineLarge,
            onPressed: () {
              context.read<LoginScreenBloc>().add(SignInWithUsernameAndPassword(
                  username: _usernameController.text));
            },
          )
        ],
      ),
    );
  }
}
