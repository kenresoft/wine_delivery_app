part of 'favs_bloc.dart';

sealed class FavsState extends Equatable {
  const FavsState();
}

final class FavsInitial extends FavsState {
  @override
  List<Object> get props => [];
}

final class FavsLoaded extends FavsState {
  final List<Product> favs;

  const FavsLoaded(this.favs);

  @override
  List<Object> get props => [favs];
}

final class FavsError extends FavsState {
  final String error;

  const FavsError({required this.error});

  @override
  List<Object> get props => [error];
}