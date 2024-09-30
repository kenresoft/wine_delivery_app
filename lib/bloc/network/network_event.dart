part of 'network_bloc.dart';

sealed class NetworkEvent extends Equatable {
  const NetworkEvent();

  @override
  List<Object?> get props => [];
}

class StartNetworkListening extends NetworkEvent {}

class GetCurrentNetworkStatus extends NetworkEvent {}

class GetNetworkStatus extends NetworkEvent {
  final bool isConnected;

  const GetNetworkStatus(this.isConnected);

  @override
  List<Object> get props => [isConnected];
}

class ShowBanner extends NetworkEvent {
  final String message;
  final ConnectionBannerStyle style;

  const ShowBanner(this.message, this.style);

  @override
  List<Object> get props => [message, style];
}

class HideBanner extends NetworkEvent {
  const HideBanner();
}
