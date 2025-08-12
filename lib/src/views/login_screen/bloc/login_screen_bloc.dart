<<<<<<< HEAD
import 'package:easy_localization/easy_localization.dart';
=======
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:taskflow/src/data/model/response/response_data.dart';
import 'package:taskflow/src/data/model/user/user_data.dart';
import 'package:taskflow/src/data/repository/repository.dart';
import 'package:taskflow/src/utils/app_export.dart';
import 'package:taskflow/src/utils/launch_url.dart';
<<<<<<< HEAD
import 'package:taskflow/src/utils/network_info.dart/network_info.dart';
import 'package:taskflow/src/utils/token_storage.dart';
=======
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
import 'package:taskflow/src/views/login_screen/bloc/login_screen_event.dart';
import 'package:taskflow/src/views/login_screen/bloc/login_screen_state.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {
  LoginScreenBloc(super.key) {
    on<SignInWithGoogle>(_onSignInWithGoogle);
    on<FetchUserDetailEvent>(_onFetchUserDetail);
<<<<<<< HEAD
    on<SignInWithUsernameAndPassword>(_onSignIn);
    on<ResetState>(_onResetState);
=======
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
  }

  final _repository = Repository();

<<<<<<< HEAD
  final _logger = Logger();

  Future<void> _onSignInWithGoogle(
=======
  final logger = Logger();

  _onSignInWithGoogle(
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
    SignInWithGoogle event,
    Emitter<LoginScreenState> emit,
  ) async {
    String url =
        'https://projectmanager-i5nz.onrender.com/oauth2/authorization/google';
    LaunchUrl().openUrl(url);
  }

<<<<<<< HEAD
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
=======
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
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
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
<<<<<<< HEAD
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
=======
      logger.i('Can not update FCM token to user $userId');
    }
  }
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
}
