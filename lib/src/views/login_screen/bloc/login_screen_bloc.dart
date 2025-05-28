// import 'package:android_intent_plus/android_intent.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:taskflow/main.dart';
import 'package:taskflow/src/data/model/response/response_data.dart';
import 'package:taskflow/src/data/model/user/user_data.dart';
import 'package:taskflow/src/data/repository/repository.dart';
import 'package:taskflow/src/utils/app_export.dart';
import 'package:taskflow/src/utils/launch_url.dart';
import 'package:taskflow/src/views/login_screen/bloc/login_screen_event.dart';
import 'package:taskflow/src/views/login_screen/bloc/login_screen_state.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {
  LoginScreenBloc(super.key) {
    on<SignInWithGoogle>(_onSignInWithGoogle);
    on<FetchUserDetailEvent>(_onFetchUserDetail);
  }

  final _repository = Repository();

  final logger = Logger();

  _onSignInWithGoogle(
    SignInWithGoogle event,
    Emitter<LoginScreenState> emit,
  ) async {
    String url =
        'https://projectmanager-i5nz.onrender.com/oauth2/authorization/google';
    LaunchUrl().openUrl(url);
  }

  _onFetchUserDetail(
    FetchUserDetailEvent event,
    Emitter<LoginScreenState> emit,
  ) async {
    await _repository.getUserDetail().then((value) async {
      if (value.statusCode == 200) {
        ResponseData<UserData> responseData =
            ResponseData.fromJson(value.data, UserData.fromJson);
        PrefUtils().setUser(responseData.data!);
        await _onUpdateToken(responseData.data!.id!);
        NavigatorService.pushNamedAndRemoveUtil(AppRoutes.homeScreen);
      }
    });
  }

  _onUpdateToken(String userId) async {
    String? tokenFcm = await FirebaseMessaging.instance.getToken();
    String locale = PlatformDispatcher.instance.locale.languageCode;
    Map<String, dynamic> requestData = {
      "userId": userId,
      "fcmToken": tokenFcm,
      "language": locale,
    };
    if (tokenFcm != null) {
      await _repository.updateToken(requestData: requestData);
    } else {
      logger.i('Can not update FCM token to user $userId');
    }
  }
}
