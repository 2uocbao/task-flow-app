import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:taskflow/src/data/model/response/response_data.dart';
import 'package:taskflow/src/data/model/user/user_data.dart';
import 'package:taskflow/src/data/repository/repository.dart';
import 'package:taskflow/src/utils/app_export.dart';
import 'package:taskflow/src/utils/launch_url.dart';
import 'package:taskflow/src/utils/network_info.dart/network_info.dart';
import 'package:taskflow/src/utils/token_storage.dart';
import 'package:taskflow/src/views/login_screen/bloc/login_screen_event.dart';
import 'package:taskflow/src/views/login_screen/bloc/login_screen_state.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {
  LoginScreenBloc(super.key) {
    on<SignInWithGoogle>(_onSignInWithGoogle);
    on<FetchUserDetailEvent>(_onFetchUserDetail);
    on<SignInWithUsernameAndPassword>(_onSignIn);
    on<ResetState>(_onResetState);
  }

  final _repository = Repository();

  final _logger = Logger();

  Future<void> _onSignInWithGoogle(
    SignInWithGoogle event,
    Emitter<LoginScreenState> emit,
  ) async {
    String url =
        'https://projectmanager-i5nz.onrender.com/oauth2/authorization/google';
    LaunchUrl().openUrl(url);
  }

  Future<void> _onFetchUserDetail(
    FetchUserDetailEvent event,
    Emitter<LoginScreenState> emit,
  ) async {
    try {
      await _repository.getUserDetail().then((value) async {
        if (value.statusCode == 200) {
          ResponseData<UserData> responseData =
              ResponseData.fromJson(value.data, UserData.fromJson);
          PrefUtils().setUser(responseData.data!);
          await _onUpdateToken(responseData.data!.id!);
          NavigatorService.pushNamedAndRemoveUtil(AppRoutes.homeScreen);
        } else {
          emit(SignInFailure('lbl_error'.tr()));
        }
      });
    } catch (e) {
      if (e is NoInternetException) {
        emit(SignInFailure('error_no_internet'.tr()));
      } else {
        emit(SignInFailure('lbl_error'.tr()));
      }
    }
  }

  Future<void> _onUpdateToken(String userId) async {
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
      _logger.i('Can not update FCM token to user $userId');
    }
  }

  Future<void> _onSignIn(
    SignInWithUsernameAndPassword event,
    Emitter<LoginScreenState> emit,
  ) async {
    try {
      Map<String, dynamic> queryParam = <String, dynamic>{
        'email': event.username,
      };
      if (event.username.isNotEmpty) {
        await _repository
            .getUserByEmail(queryParam: queryParam)
            .then((value) async {
          if (value.statusCode == 200) {
            ResponseData response = ResponseData.fromJsonToken(value.data);
            await TokenStorage.saveToken(response.data);
            add(FetchUserDetailEvent());
          } else {
            emit(SignInFailure('lbl_error'.tr()));
          }
        });
      } else {
        emit(SignInFailure('lbl_error'.tr()));
      }
    } catch (e) {
      if (e is NoInternetException) {
        emit(SignInFailure('error_no_internet'.tr()));
      } else {
        emit(SignInFailure('lbl_error'.tr()));
      }
    }
  }

  void _onResetState(
    ResetState event,
    Emitter<LoginScreenState> emit,
  ) {
    emit(LoginScreenState());
  }
}
