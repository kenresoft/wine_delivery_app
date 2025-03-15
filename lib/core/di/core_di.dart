import 'package:flutter_bloc/flutter_bloc.dart';

import '../network/api_service.dart';
import '../network/dio_client.dart';

class CoreDI {
  static List<RepositoryProvider> providers(/*DioClient dioClient, */ApiService apiService) {
    return [
      // RepositoryProvider<DioClient>(create: (_) => dioClient),
      RepositoryProvider<ApiService>(create: (_) => apiService),
    ];
  }
}
