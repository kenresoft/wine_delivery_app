import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintiora/features/auth/domain/usecases/register_usecase.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterBloc({required this.registerUseCase}) : super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());

    final result = await registerUseCase(
      event.username,
      event.email,
      event.password,
    );

    result.fold(
      (failure) => emit(RegisterFailure(failure.message)),
      (message) => emit(RegisterSuccess(message)),
    );
  }
}
