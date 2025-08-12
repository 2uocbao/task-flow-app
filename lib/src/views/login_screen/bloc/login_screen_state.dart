import 'package:equatable/equatable.dart';

class LoginScreenState extends Equatable {
  @override
  List<Object?> get props => [];
}

<<<<<<< HEAD
class SignInFailure extends LoginScreenState {
  final String error;
  SignInFailure(this.error);
}

class SignInSuccess extends LoginScreenState {}
=======
class SignInLoading extends LoginScreenState {}

class SignInSuccess extends LoginScreenState {}

class SignInFalure extends LoginScreenState {}
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
