import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vintiora/repository/user_repository.dart';

import '../../model/profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileFetching()) {
    on<ProfileFetch>((event, emit) async {
      try {
        final Profile profile = await userRepository.getUserProfile();
        emit(ProfileLoaded(profile));
      } catch (e) {
        emit(ProfileError(error: e.toString()));
      }
    });
  }
}
