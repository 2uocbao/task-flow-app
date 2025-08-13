abstract class LoginScreenEvent {}

class FetchUserDetailEvent extends LoginScreenEvent {}

class SignInWithGoogle extends LoginScreenEvent {}

class ResetState extends LoginScreenEvent {}

class SignInWithUsernameAndPassword extends LoginScreenEvent {
  final String username;
  SignInWithUsernameAndPassword({required this.username});
}