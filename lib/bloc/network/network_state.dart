part of 'network_bloc.dart';

sealed class NetworkState extends Equatable {
  const NetworkState();

  @override
  List<Object?> get props => [];
}

/*class NetworkInitial extends NetworkState {}

class NetworkLoading extends NetworkState {}*/

class NetworkConnected extends NetworkState {
  final bool isConnected;

  const NetworkConnected(this.isConnected);

  @override
  List<Object> get props => [isConnected];
}

class NetworkDisconnected extends NetworkState {
  const NetworkDisconnected();
}

class NetworkError extends NetworkState {
  final String message;

  const NetworkError(this.message);

  @override
  List<Object> get props => [message];
}

class BannerVisible extends NetworkState {
  final String message;
  final ConnectionBannerStyle style;

  const BannerVisible(this.message, this.style);

  @override
  List<Object> get props => [message, style];
}

class BannerHidden extends NetworkState {
  const BannerHidden();
}
