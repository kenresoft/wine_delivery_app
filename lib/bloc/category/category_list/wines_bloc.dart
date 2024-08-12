import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

import '../../../model/wine.dart';

part 'wines_event.dart';

part 'wines_state.dart';

class WinesBloc extends Bloc<WinesEvent, WinesState> {
  WinesBloc() : super(const WinesLoaded(wines: [])) {
    on<WinesReady>((event, emit) async {
      try {
        final jsonString = await rootBundle.loadString('assets/winest.json');
        final List<dynamic> decodedData = jsonDecode(jsonString) as List<dynamic>;
        final List<Wine> wines = decodedData.map((dynamic item) => Wine.fromJson(item)).toList();
        emit(WinesLoaded(wines: wines));
      } catch (e) {
        emit(WinesLoaded(wines: [Wine.error()]));
      }
    });
  }
}
