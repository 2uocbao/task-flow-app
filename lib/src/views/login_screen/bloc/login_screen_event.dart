import 'package:equatable/equatable.dart';

class LoginScreenEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUserDetailEvent extends LoginScreenEvent {}

class SignInWithGoogle extends LoginScreenEvent {}
