part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginOtpSent extends LoginState {
  final String message;
  final String email;

  const LoginOtpSent({
    required this.message,
    required this.email,
  });

  @override
  List<Object> get props => [message, email];
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure(this.error);

  @override
  List<Object> get props => [error];
}
