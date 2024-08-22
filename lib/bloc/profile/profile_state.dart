part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();
}

final class ProfileFetching extends ProfileState {

  const ProfileFetching();

  @override
  List<Object> get props => [];
}


final class ProfileLoaded extends ProfileState {
  final Profile profile;

  const ProfileLoaded(this.profile);

  @override
  List<Object> get props => [profile];
}

// TODO: Profile Error