import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'promo_code_event.dart';

part 'promo_code_state.dart';

class PromoCodeBloc extends Bloc<PromoCodeEvent, PromoCodeState> {
  PromoCodeBloc() : super(PromoCodeInitial()) {
    on<InitPromoCode>(initPromoCode);
    on<UpdatePromoCode>(updatePromoCode);
  }

  void initPromoCode(PromoCodeEvent event, Emitter<PromoCodeState> emit) {
    emit(PromoCodeInitial());
  }

  void updatePromoCode(PromoCodeEvent event, Emitter<PromoCodeState> emit) {
    emit(PromoCodeApplied());
  }
}
