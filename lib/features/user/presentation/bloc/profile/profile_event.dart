part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class ProfileFetch extends ProfileEvent {
  const ProfileFetch();

  @override
  List<Object?> get props => [];
}