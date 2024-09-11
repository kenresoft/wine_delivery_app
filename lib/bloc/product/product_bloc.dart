import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/product.dart';
import '../../repository/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<GetAllProducts>(getAllProducts);
    on<GetProductsByIds>(getProductsByIds);
    on<GetProductById>(getProductById);
    on<CreateProduct>(createProduct);
    on<UpdateProduct>(updateProduct);
    on<DeleteProduct>(deleteProduct);
  }

  Future<void> getAllProducts(GetAllProducts event, Emitter<ProductState> emit) async {
    try {
      final products = await productRepository.getAllProducts();
      emit(ProductsLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> getProductsByIds(GetProductsByIds event, Emitter<ProductState> emit) async {
    try {
      final products = await productRepository.getProductsByIds(event.productIds);
      emit(ProductsLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> getProductById(GetProductById event, Emitter<ProductState> emit) async {
    try {
      final product = await productRepository.getProductById(event.productId);
      emit(ProductLoaded(product));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> createProduct(CreateProduct event, Emitter<ProductState> emit) async {
    try {
      final product = await productRepository.createProduct(event.product);
      emit(ProductCreated(product));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> updateProduct(UpdateProduct event, Emitter<ProductState> emit) async {
    try {
      final product = await productRepository.updateProduct(event.productId, event.product);
      emit(ProductUpdated(product));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> deleteProduct(DeleteProduct event, Emitter<ProductState> emit) async {
    try {
      await productRepository.deleteProduct(event.productId);
      emit(ProductDeleted(event.productId));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
