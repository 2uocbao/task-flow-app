import 'package:dio/dio.dart';
import 'package:taskflow/src/utils/app_export.dart';

class NetworkInterceptor extends Interceptor {
  final logger = Logger();
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e('❌ Error: ${err.message}');
    super.onError(err, handler);
  }
}
