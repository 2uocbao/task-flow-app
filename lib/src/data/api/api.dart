import 'dart:io';

import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taskflow/src/data/api/network_interceptor.dart';
import 'package:taskflow/src/data/model/refreshToken/refresh_token.dart';
import 'package:taskflow/src/data/model/response/response_data.dart';
import 'package:taskflow/src/service/notification_service.dart';
import 'package:taskflow/src/utils/app_export.dart';
export 'package:taskflow/src/utils/app_export.dart';
import 'package:taskflow/src/utils/network_info.dart/network_info.dart';
import 'package:taskflow/src/utils/progress_dialog_utils.dart';
import 'package:taskflow/src/utils/token_storage.dart';

class Api {
  final logger = Logger();

  factory Api() {
    return _api;
  }

  Api._internal();

  // var url = "https://projectmanager-i5nz.onrender.com";

  var url = "http://192.168.1.3:9091";

  static final Api _api = Api._internal();

  final _dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 5)))
    ..interceptors.add(NetworkInterceptor());

  late String? token;

  Future isNetWorkConnected() async {
    if (!await NetworkInfo().isConnected()) {
      throw NoInternetException('No Internet!');
    }
  }

  void clearTokenAndRefresh() async {}

  Future<Response> getUserTest(String path,
      {Map<String, dynamic> queryParam = const {}}) async {
    ProgressDialogUtils.showProgressDialog();
    try {
      await isNetWorkConnected();
      Response response = await _dio
          .get(url + path, queryParameters: queryParam, options: Options(
        validateStatus: (status) {
          return true;
        },
      ));
      ProgressDialogUtils.hideProgressDialog();
      return response;
    } catch (e) {
      ProgressDialogUtils.hideProgressDialog();
      rethrow;
    }
  }

  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted) {
        return true;
      }

      // Android 11+ (API 30)
      if (await Permission.manageExternalStorage.request().isGranted) {
        return true;
      }

      // Nếu từ chối
      await openAppSettings(); // Mở phần Cài đặt
      return false;
    }
    return true;
  }

  Future<void> refreshToken() async {
    ProgressDialogUtils.showProgressDialog();

    try {
      await isNetWorkConnected();
      Response response;
      String? refresh;
      await TokenStorage.getRefresh().then((value) {
        refresh = value;
      });
      final requestData = RefreshToken(refresh: refresh);
      response = await _dio.get(
        '$url/users/refresh-token',
        data: requestData.toJson(),
      );
      if (response.statusCode == 200) {
        ResponseData<RefreshToken> responseData =
            ResponseData.fromJson(response.data, RefreshToken.fromJson);
        logger.i('Refresh Token Success ${responseData.data!.refresh!}');
        await TokenStorage.saveToken(responseData.data!.refresh!);
      } else {
        PrefUtils().clearPreferentcesData();
        NavigatorService.pushNamedAndRemoveUtil(AppRoutes.loginScreen);
      }
    } catch (e) {
      ProgressDialogUtils.hideProgressDialog();

      rethrow;
    }
  }

  Future<Response> post(String path,
      {Map requestData = const {},
      Map<String, dynamic> queryParam = const {}}) async {
    ProgressDialogUtils.showProgressDialog();

    try {
      await isNetWorkConnected();
      Response response;
      response = await postApi(path, requestData: requestData);
      if (response.statusCode == 401) {
        await refreshToken();
        response = await post(path, requestData: requestData);
      }
      ProgressDialogUtils.hideProgressDialog();
      return response;
    } catch (e) {
      ProgressDialogUtils.hideProgressDialog();

      rethrow;
    }
  }

  Future<Response> postApi(String path, {Map requestData = const {}}) async {
    await TokenStorage.getToken().then((value) async {
      token = value;
    });
    return await _dio.post(
      url + path,
      data: requestData,
      options: Options(
        headers: <String, dynamic>{
          'Authorization': 'Bearer $token',
        },
        validateStatus: (status) {
          return true;
        },
      ),
    );
  }

  Future<Response> get(String path,
      {Map<String, dynamic> queryParam = const {}}) async {
    ProgressDialogUtils.showProgressDialog();

    try {
      await isNetWorkConnected();
      Response response;
      response = await getApi(path, queryParam: queryParam);
      if (response.statusCode == 401) {
        await refreshToken();
        response = await getApi(path, queryParam: queryParam);
      }
      ProgressDialogUtils.hideProgressDialog();
      return response;
    } catch (e) {
      ProgressDialogUtils.hideProgressDialog();

      rethrow;
    }
  }

  Future<Response> getApi(String path,
      {Map<String, dynamic> queryParam = const {}}) async {
    await TokenStorage.getToken().then((value) async {
      token = value;
    });
    return await _dio.get(
      url + path,
      queryParameters: queryParam,
      options: Options(
        headers: <String, dynamic>{
          'Authorization': 'Bearer $token',
        },
        validateStatus: (status) {
          return true;
        },
      ),
    );
  }

  Future<Response> put(String path, {Map requestData = const {}}) async {
    ProgressDialogUtils.showProgressDialog();

    try {
      await isNetWorkConnected();
      Response response;
      response = await putApi(path, requestData: requestData);
      if (response.statusCode == 401) {
        await refreshToken();
        response = await putApi(path, requestData: requestData);
      }
      ProgressDialogUtils.hideProgressDialog();
      return response;
    } catch (e) {
      ProgressDialogUtils.hideProgressDialog();

      rethrow;
    }
  }

  Future<Response> putApi(String path, {Map requestData = const {}}) async {
    await TokenStorage.getToken().then((value) async {
      token = value;
    });
    return await _dio.put(
      url + path,
      data: requestData,
      options: Options(
        headers: <String, dynamic>{
          'Authorization': 'Bearer $token',
        },
        validateStatus: (status) {
          return true;
        },
      ),
    );
  }

  Future<Response> delete(String path) async {
    ProgressDialogUtils.showProgressDialog();

    try {
      await isNetWorkConnected();
      Response response;
      response = await deleteApi(path);
      if (response.statusCode == 401) {
        await refreshToken();
        response = await deleteApi(path);
      }
      ProgressDialogUtils.hideProgressDialog();
      return response;
    } catch (e) {
      ProgressDialogUtils.hideProgressDialog();

      rethrow;
    }
  }

  Future<Response> deleteApi(String path) async {
    await TokenStorage.getToken().then((value) async {
      token = value;
    });
    return _dio.delete(
      url + path,
      options: Options(
        headers: <String, dynamic>{
          'Authorization': 'Bearer $token',
        },
        validateStatus: (status) {
          return true;
        },
      ),
    );
  }

  Future<Response> addFile(String path, FormData formData) async {
    ProgressDialogUtils.showProgressDialog();

    try {
      await isNetWorkConnected();
      Response response;
      response = await requestAddFile(path, formData);
      if (response.statusCode == 401) {
        await refreshToken();
        response = await requestAddFile(path, formData);
      }
      ProgressDialogUtils.hideProgressDialog();
      return response;
    } catch (e) {
      ProgressDialogUtils.hideProgressDialog();

      rethrow;
    }
  }

  Future<Response> requestAddFile(String path, FormData formData) async {
    await TokenStorage.getToken().then((value) async {
      token = value;
    });
    return await _dio.post(
      url + path,
      data: formData,
      options: Options(
        headers: <String, dynamic>{
          'Authorization': 'Bearer $token',
        },
        validateStatus: (status) {
          return true;
        },
        contentType: 'multipart/form-data',
      ),
    );
  }

  Future<void> downloadFile(String path, String fileName,
      {Map<String, dynamic> queryParam = const {}}) async {
    try {
      bool hasPermission = await requestStoragePermission();
      if (!hasPermission) return;
      logger.i(hasPermission);
      Directory? dcim = Directory('/storage/emulated/0/DCIM/MyFolder');
      checkFileExists('$dcim/path').then((exists) {
        if (exists) {
          return;
        }
      });
      if (!await dcim.exists()) {
        await dcim.create(recursive: true);
      }
      ProgressDialogUtils.showProgressDialog();
      String savePath = '${dcim.path}/$fileName';

      Response response;
      response = await requestDownload(path, fileName, savePath,
          queryParam: queryParam);
      if (response.statusCode == 401) {
        await refreshToken();

        response = await requestDownload(path, fileName, savePath,
            queryParam: queryParam);
      }
      ProgressDialogUtils.hideProgressDialog();
    } catch (e) {
      ProgressDialogUtils.hideProgressDialog();

      rethrow;
    }
  }

  Future<Response> requestDownload(
      String path, String fileName, String savePath,
      {Map<String, dynamic> queryParam = const {}}) async {
    await TokenStorage.getToken().then((value) async {
      token = value;
    });
    return await _dio.download(
      url + path,
      queryParameters: queryParam,
      options: Options(
        headers: <String, dynamic>{
          'Authorization': 'Bearer $token',
        },
      ),
      savePath,
      onReceiveProgress: (count, total) {
        if (total != -1) {
          NotificationService().showNotification(fileName);
        }
      },
    );
  }

  Future<bool> checkFileExists(String path) async {
    File file = File(path);
    return await file.exists();
  }

  Future<Response> search(String path,
      {Map<String, dynamic> requestParam = const {}}) async {
    try {
      await isNetWorkConnected();
      Response response;
      response = await searchRequest(path, requestParam: requestParam);
      if (response.statusCode == 401) {
        await refreshToken();
        response = await searchRequest(path, requestParam: requestParam);
      }
      return response;
    } catch (e) {
      ProgressDialogUtils.hideProgressDialog();
      rethrow;
    }
  }

  Future<Response> searchRequest(String path,
      {Map<String, dynamic> requestParam = const {}}) async {
    await TokenStorage.getToken().then((value) async {
      token = value;
    });
    return await _dio.get(
      url + path,
      queryParameters: requestParam,
      options: Options(
        headers: <String, dynamic>{'Authorization': 'Bearer $token'},
      ),
    );
  }
}
