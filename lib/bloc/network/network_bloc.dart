/*
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

import '../../repository/network_repository.dart';
import '../../views/connection_banner_style.dart';

part 'network_event.dart';

part 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  StreamSubscription<List<ConnectivityResult>>? _networkSubscription;

  NetworkBloc() : super(NetworkInitial()) {
    on<StartNetworkListening>(_startListening);
    on<GetCurrentNetworkStatus>(_getCurrentNetworkStatus);
    on<GetNetworkStatus>(_onNetwork);
    on<ShowBanner>(_onShowBanner);
    on<HideBanner>(_onHideBanner);
  }

  Future<void> _startListening(StartNetworkListening event, Emitter<NetworkState> emit) async {
    try {
      // Listen to network changes
      _networkSubscription = networkRepository.startListening().listen((result) async {
        final isConnected = await networkRepository.isConnected();
        add(GetNetworkStatus(isConnected));
      });
    } catch (e) {
      emit(NetworkError(e.toString()));
    }
  }

  void _onNetwork(GetNetworkStatus event, Emitter<NetworkState> emit) {
    if (event.isConnected) {
      emit(const NetworkConnected(true));
      add(ShowBanner("Internet connection is available", ConnectionBannerStyle.online()));
    } else {
      emit(const NetworkDisconnected());
      add(ShowBanner("No internet connection!", ConnectionBannerStyle.offline()));
    }

    // Hide the banner after a delay
    Future.delayed(const Duration(seconds: 5), () {
      add(HideBanner());
    });
  }

  Future<void> _getCurrentNetworkStatus(GetCurrentNetworkStatus event, Emitter<NetworkState> emit) async {
    emit(NetworkLoading());

    try {
      // Get current network status
      final result = await networkRepository.initConnectivity();
      final isConnected = await networkRepository.isConnected();

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
    emit(BannerHidden());
  }

  @override
  Future<void> close() {
    _networkSubscription?.cancel();
    return super.close();
  }
}
*/

/*import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

import '../../repository/network_repository.dart';
import '../../utils/internet_connection_checker.dart';
import '../../utils/internet_connection_result.dart';
import '../../views/connection_banner_style.dart';

part 'network_event.dart';

part 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  StreamSubscription<List<ConnectivityResult>>? _networkSubscription;
  StreamSubscription<InternetConnectionResult>? _internetSubscription;

  NetworkBloc() : super(NetworkInitial()) {
    on<StartNetworkListening>(_startListening);
    on<GetCurrentNetworkStatus>(_getCurrentNetworkStatus);
    on<GetNetworkStatus>(_onNetwork);
    on<ShowBanner>(_onShowBanner);
    on<HideBanner>(_onHideBanner);
  }

  Future<void> _startListening(StartNetworkListening event, Emitter<NetworkState> emit) async {
    try {
      // Start listening to basic connectivity changes (e.g., WiFi, mobile)
      _networkSubscription = networkRepository.startListening().listen((result) async {
        final isConnected = await networkRepository.isConnected();
        add(GetNetworkStatus(isConnected));
      });

      // Start listening to more reliable internet checks from InternetConnectionChecker
      internetConnectionChecker.startListening();
      _internetSubscription = internetConnectionChecker.connectionStream.listen((connectionResult) {
        add(GetNetworkStatus(connectionResult.isConnected));
      });
    } catch (e) {
      emit(NetworkError(e.toString()));
    }
  }

  void _onNetwork(GetNetworkStatus event, Emitter<NetworkState> emit) {
    if (event.isConnected) {
      emit(const NetworkConnected(true));
      add(ShowBanner("Internet connection is available", ConnectionBannerStyle.online()));
    } else {
      emit(const NetworkDisconnected());
      add(ShowBanner("No internet connection!", ConnectionBannerStyle.offline()));
    }

    // Hide the banner after a delay
    Future.delayed(const Duration(seconds: 5), () {
      add(HideBanner());
    });
  }

  Future<void> _getCurrentNetworkStatus(GetCurrentNetworkStatus event, Emitter<NetworkState> emit) async {
    emit(NetworkLoading());

    try {
      // Check current network status using repository
      final result = await networkRepository.initConnectivity();
      final isConnected = await networkRepository.isConnected();

      // Further verify with your custom internet connection checker
      final connectionResult = await internetConnectionChecker.hasInternetConnection();
      final fullyConnected = connectionResult.isConnected;

      if (fullyConnected) {
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
    emit(BannerHidden());
  }

  @override
  Future<void> close() {
    _networkSubscription?.cancel();
    _internetSubscription?.cancel();
    internetConnectionChecker.dispose(); // Dispose the custom checker properly
    return super.close();
  }
}*/

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:extensionresoft/extensionresoft.dart';

import '../../views/connection_banner_style.dart';

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
        add(GetNetworkStatus(isConnected));
      });

      /*_networkSubscription = internet.onInternetConnectivityChanged.listen((result) async {
        add(GetNetworkStatus(result.hasInternetAccess));
      });*/
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
