import 'package:equatable/equatable.dart';

class LoginScreenState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignInLoading extends LoginScreenState {}

class SignInSuccess extends LoginScreenState {}

class SignInFalure extends LoginScreenState {}
