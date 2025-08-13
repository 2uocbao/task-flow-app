import 'package:equatable/equatable.dart';

class LoginScreenState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignInFailure extends LoginScreenState {
  final String error;
  SignInFailure(this.error);
}

class SignInSuccess extends LoginScreenState {}
