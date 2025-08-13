import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:taskflow/main.dart';

abstract class NetWorkInfo {
  Future<bool> isConnected();

  Future<List<ConnectivityResult>> get connectivityResult;

  Stream<List<ConnectivityResult>> get onConnectivityChanged;
}

class NetworkInfo implements NetWorkInfo {
  Connectivity connectivity;

  static final NetworkInfo _networdInfo = NetworkInfo._internal(Connectivity());

  factory NetworkInfo() {
    return _networdInfo;
  }

  NetworkInfo._internal(this.connectivity) {
    connectivity = connectivity;
  }

  @override
  Future<bool> isConnected() async {
    final result = await connectivityResult;
    return !result.contains(ConnectivityResult.none);
  }

  @override
  Future<List<ConnectivityResult>> get connectivityResult async {
    return connectivity.checkConnectivity();
  }

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      connectivity.onConnectivityChanged;
}

abstract class Failure {}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {}

class ServerException implements Exception {}

class CacheException implements Exception {}

class NetworkException implements Exception {}

class NoInternetException implements Exception {
  late String _message;

  NoInternetException([String message = 'NoInternetException Occurred']) {
    if (globaleMessagerKey.currentState != null) {
      globaleMessagerKey.currentState!
          .showSnackBar(SnackBar(content: Text(message)));
    }
    _message = message;
  }

  @override
  String toString() {
    return _message;
  }
}
