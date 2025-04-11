import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:vintiora/core/error/failures.dart';
import 'package:vintiora/features/cart/domain/entities/cart.dart';
import 'package:vintiora/features/cart/domain/repositories/cart_repository.dart';

class ApplyCoupon {
  final CartRepository repository;

  ApplyCoupon(this.repository);

  Future<Either<Failure, Cart>> call(CouponParams params) async {
    return await repository.applyCoupon(params.couponCode);
  }
}

class CouponParams extends Equatable {
  final String couponCode;

  const CouponParams({required this.couponCode});

  @override
  List<Object?> get props => [couponCode];
}
