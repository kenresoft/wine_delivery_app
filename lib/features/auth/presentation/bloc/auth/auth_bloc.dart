import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintiora/features/auth/domain/entities/user.dart';
import 'package:vintiora/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:vintiora/features/auth/domain/usecases/logout_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckAuthUseCase checkAuthUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
    required this.checkAuthUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await checkAuthUseCase();

    result.fold(
      (failure) => emit(Unauthenticated()),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await logoutUseCase();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(Unauthenticated()),
    );
  }
}
