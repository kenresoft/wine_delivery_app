part of 'wines_bloc.dart';

sealed class WinesState extends Equatable {
  const WinesState();
}

final class WinesLoaded extends WinesState {
  final List<Wine> wines;

  const WinesLoaded({required this.wines});

  bool get isEmpty => wines.isEmpty;

  bool get hasError => wines.contains(Wine.error());

  @override
  List<Object> get props => [wines, isEmpty];
}
