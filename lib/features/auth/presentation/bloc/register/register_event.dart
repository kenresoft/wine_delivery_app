part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  final String username;
  final String email;
  final String password;

  const RegisterSubmitted({
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [username, email, password];
}
