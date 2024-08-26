part of 'favs_bloc.dart';

sealed class FavsEvent extends Equatable {
  const FavsEvent();
}

class LoadFavs extends FavsEvent {

  @override
  List<Object?> get props => [];
}
