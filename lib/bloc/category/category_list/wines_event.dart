part of 'wines_bloc.dart';

sealed class WinesEvent extends Equatable {
  const WinesEvent();
}

class WinesReady extends WinesEvent {
  @override
  List<Object?> get props => [];
}