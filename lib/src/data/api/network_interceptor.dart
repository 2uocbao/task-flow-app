import 'package:dio/dio.dart';
<<<<<<< HEAD
import 'package:taskflow/src/utils/app_export.dart';

class NetworkInterceptor extends Interceptor {
  final logger = Logger();
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e('❌ Error: ${err.message}');
    super.onError(err, handler);
  }
}
=======

class NetworkInterceptor extends Interceptor {
  
}
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
