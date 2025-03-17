part of 'verify_otp_bloc.dart';

sealed class VerifyOtpEvent extends Equatable {
  const VerifyOtpEvent();

  @override
  List<Object> get props => [];
}

class VerifyOtpSubmitted extends VerifyOtpEvent {
  final String email;
  final String otp;

  const VerifyOtpSubmitted({
    required this.email,
    required this.otp,
  });

  @override
  List<Object> get props => [email, otp];
}
