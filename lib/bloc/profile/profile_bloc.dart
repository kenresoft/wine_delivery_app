import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wine_delivery_app/repository/user_repository.dart';
import 'package:wine_delivery_app/utils/prefs.dart';

import '../../model/product.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileFetching()) {
    on<ProfileFetch>((event, emit) async {
      print(authToken);
      final Profile profile = await userRepository.getUserProfile();
      emit(ProfileLoaded(profile));
      //emit(ProfileFetching(Profile(id: '-1', username: '', email: '', favorites: [])));
      /*try {
        final Profile profile = await userRepository.getUserProfile();
        emit(ProfileLoaded(profile));
      } on Exception catch (e) {
        emit(
          ProfileLoaded(Profile(id: e.toString(), username: e.toString(), email: e.toString(), favorites: [])),
        );
      }*/
    });
  }
}
