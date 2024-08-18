part of 'wines_bloc.dart';

enum WinesLoadStatus { loading, success, error }

class WinesState extends Equatable {
  final WinesLoadStatus status;
  final List<Product> wines;
  final String? errorMessage;

  const WinesState({
    required this.status,
    this.wines = const [],
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, wines, errorMessage];

  bool get isLoading => status == WinesLoadStatus.loading;
  bool get hasError => status == WinesLoadStatus.error;
}