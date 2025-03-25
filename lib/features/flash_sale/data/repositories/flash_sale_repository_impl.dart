import 'package:dartz/dartz.dart';
import 'package:vintiora/core/error/failures.dart';
import 'package:vintiora/features/flash_sale/data/datasources/flash_sale_remote_data_source.dart';
import 'package:vintiora/features/flash_sale/domain/entities/flash_sale.dart';
import 'package:vintiora/features/flash_sale/domain/repositories/flash_sale_repository.dart';

class FlashSaleRepositoryImpl implements FlashSaleRepository {
  final FlashSaleRemoteDataSource remoteDataSource;

  FlashSaleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<FlashSaleProduct>>> getFlashSaleProducts() async {
    final products = await remoteDataSource.getFlashSaleProducts();
    return products.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }

  @override
  Future<Either<Failure, List<FlashSale>>> getActiveFlashSales() async {
    final flashSales = await remoteDataSource.getActiveFlashSales();
    return flashSales.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }

  @override
  Future<Either<Failure, FlashSale>> getFlashSaleDetails(String id) async {
    final flashSale = await remoteDataSource.getFlashSaleDetails(id);
    return flashSale.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }
}
