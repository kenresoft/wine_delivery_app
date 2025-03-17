import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintiora/features/auth/domain/entities/user.dart';
import 'package:vintiora/features/auth/domain/usecases/get_profile_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;

  ProfileBloc({required this.getProfileUseCase}) : super(ProfileInitial()) {
    on<GetProfileRequested>(_onGetProfileRequested);
  }

  Future<void> _onGetProfileRequested(
    GetProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    final result = await getProfileUseCase();

    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (user) => emit(ProfileLoaded(user)),
    );
  }
}
