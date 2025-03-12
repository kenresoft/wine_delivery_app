import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintiora/core/utils/helpers.dart';

import '../../config/app_config.dart';
import '../../router/nav.dart';
import '../../storage/preferences.dart';

part 'network_event.dart';
part 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  final InternetConnectionChecker _internetConnectionChecker;
  StreamSubscription? _subscription;

  NetworkBloc(this._internetConnectionChecker) : super(const NetworkDisconnected()) {
    on<StartNetworkListening>(_startListening);
    on<GetNetworkStatus>(_onNetwork);
  }

  Future<void> _startListening(StartNetworkListening event, Emitter<NetworkState> emit) async {
    try {
      if (!isWeb) {
        _subscription = _internetConnectionChecker.onIsInternetConnected.listen((isConnected) {
          isInternet = isConnected;
          logger.i('$isConnected');
          add(GetNetworkStatus(isConnected));
        });
      }
    } catch (e) {
      emit(NetworkError(e.toString()));
    }
  }

  void _onNetwork(GetNetworkStatus event, Emitter<NetworkState> emit) {
    // Check if the network state has changed
    if (event.isConnected) {
      Nav.showBanner("Internet connection is available");
      if (eventsLoadedBefore) {
        Config.loadEvents();
      } else {
        eventsLoadedBefore = true;
      }
      emit(const NetworkConnected(true));
    } else {
      Nav.showBanner("No internet connection!");
      emit(const NetworkDisconnected());
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _subscription = null;
    return super.close();
  }
}
