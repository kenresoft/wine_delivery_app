import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:extensionresoft/extensionresoft.dart';
import 'package:vintiora/utils/preferences.dart';


part 'network_event.dart';
part 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  StreamSubscription<InternetResult>? _networkSubscription;
  final internet = InternetConnectionChecker();

  NetworkBloc() : super(const NetworkDisconnected()) {
    on<StartNetworkListening>(_startListening);
    on<GetNetworkStatus>(_onNetwork);
    on<ShowBanner>(_onShowBanner);
    on<HideBanner>(_onHideBanner);
    on<GetCurrentNetworkStatus>(_getCurrentNetworkStatus);
  }

  Future<void> _startListening(StartNetworkListening event, Emitter<NetworkState> emit) async {
    try {
      internet.onConnectedToInternet.listen((isConnected) {
        isInternet = isConnected;
        add(GetNetworkStatus(isConnected));
      });
    } catch (e) {
      emit(NetworkError(e.toString()));
    }
  }

  void _onNetwork(GetNetworkStatus event, Emitter<NetworkState> emit) {
    // Check if the network state has changed
    if (event.isConnected) {
      emit(const NetworkConnected(true));
      add(ShowBanner("Internet connection is available", ConnectionBannerStyle.online()));
    } else {
      emit(const NetworkDisconnected());
      add(ShowBanner("No internet connection!", ConnectionBannerStyle.offline()));
    }

    // Hide the banner after a delay
    Future.delayed(const Duration(seconds: 5), () {
      add(const HideBanner());
    });
  }

  // Add the event handler for GetCurrentNetworkStatus
  // Useful to be called when the app resumes.
  Future<void> _getCurrentNetworkStatus(GetCurrentNetworkStatus event, Emitter<NetworkState> emit) async {
    try {
      final isConnected = await internet.hasInternetAccess();

      if (isConnected) {
        emit(const NetworkConnected(true));
        add(ShowBanner("Internet connection is available", ConnectionBannerStyle.online()));
      } else {
        emit(const NetworkDisconnected());
        add(ShowBanner("No internet connection!", ConnectionBannerStyle.offline()));
      }
    } catch (e) {
      emit(NetworkError(e.toString()));
    }
  }

  void _onShowBanner(ShowBanner event, Emitter<NetworkState> emit) {
    emit(BannerVisible(event.message, event.style));
  }

  void _onHideBanner(HideBanner event, Emitter<NetworkState> emit) {
    emit(const BannerHidden());
  }

  @override
  Future<void> close() {
    _networkSubscription?.cancel();
    internet.dispose();
    return super.close();
  }
}
