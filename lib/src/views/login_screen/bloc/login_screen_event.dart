<<<<<<< HEAD
abstract class LoginScreenEvent {}
=======
import 'package:equatable/equatable.dart';

class LoginScreenEvent extends Equatable {
  @override
  List<Object?> get props => [];
}
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7

class FetchUserDetailEvent extends LoginScreenEvent {}

class SignInWithGoogle extends LoginScreenEvent {}
<<<<<<< HEAD

class ResetState extends LoginScreenEvent {}

class SignInWithUsernameAndPassword extends LoginScreenEvent {
  final String username;
  SignInWithUsernameAndPassword({required this.username});
}
=======
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
