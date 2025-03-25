import 'package:dartz/dartz.dart';
import 'package:vintiora/core/error/failures.dart';

import '../entities/flash_sale.dart';

abstract class FlashSaleRepository {
  /// Fetches all flash sale products
  Future<Either<Failure, List<FlashSaleProduct>>> getFlashSaleProducts();

  /// Fetches active flash sales
  Future<Either<Failure, List<FlashSale>>> getActiveFlashSales();

  /// Fetches details for a specific flash sale
  Future<Either<Failure, FlashSale>> getFlashSaleDetails(String id);
}
