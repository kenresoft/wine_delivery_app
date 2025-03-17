part of 'verify_otp_bloc.dart';

sealed class VerifyOtpState extends Equatable {
  const VerifyOtpState();

  @override
  List<Object?> get props => [];
}

class VerifyOtpInitial extends VerifyOtpState {}

class VerifyOtpLoading extends VerifyOtpState {}

class VerifyOtpSuccess extends VerifyOtpState {
  final User user;
  final AuthTokens tokens;

  const VerifyOtpSuccess({
    required this.user,
    required this.tokens,
  });

  @override
  List<Object> get props => [user, tokens];
}

class VerifyOtpFailure extends VerifyOtpState {
  final String error;

  const VerifyOtpFailure(this.error);

  @override
  List<Object> get props => [error];
}
