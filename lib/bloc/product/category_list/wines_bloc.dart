import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:wine_delivery_app/repository/product_repository.dart';

import '../../../model/product.dart';

part 'wines_event.dart';
part 'wines_state.dart';

class WinesBloc extends Bloc<WinesEvent, WinesState> {
  WinesBloc() : super(const WinesState(status: WinesLoadStatus.loading)) {
    on<WinesReady>((event, emit) async {
      try {
        //final jsonString = await rootBundle.loadString('assets/wines.json');
        //final List<dynamic> decodedData = jsonDecode(jsonString) as List<dynamic>;
        //final List<Product> wines = decodedData.map((dynamic item) => Product.fromJson(item)).toList();

        final List<Product> products = await productRepository.getAllProducts();

        emit(WinesState(status: WinesLoadStatus.success, wines: products));
      } catch (e) {
        debugPrint(e.toString());
        emit(WinesState(status: WinesLoadStatus.error, errorMessage: e.toString()));
      }
    });
  }
}