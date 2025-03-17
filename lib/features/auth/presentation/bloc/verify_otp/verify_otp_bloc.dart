import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vintiora/features/auth/domain/entities/auth_tokens.dart';
import 'package:vintiora/features/auth/domain/entities/user.dart';
import 'package:vintiora/features/auth/domain/usecases/verify_otp_usecase.dart';

part 'verify_otp_event.dart';
part 'verify_otp_state.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final VerifyOtpUseCase verifyOtpUseCase;

  VerifyOtpBloc({required this.verifyOtpUseCase}) : super(VerifyOtpInitial()) {
    on<VerifyOtpSubmitted>(_onVerifyOtpSubmitted);
  }

  Future<void> _onVerifyOtpSubmitted(
    VerifyOtpSubmitted event,
    Emitter<VerifyOtpState> emit,
  ) async {
    emit(VerifyOtpLoading());

    final result = await verifyOtpUseCase(
      event.email,
      event.otp,
    );

    result.fold(
      (failure) => emit(VerifyOtpFailure(failure.message)),
      (tuple) => emit(VerifyOtpSuccess(
        user: tuple.value1,
        tokens: tuple.value2,
      )),
    );
  }
}
