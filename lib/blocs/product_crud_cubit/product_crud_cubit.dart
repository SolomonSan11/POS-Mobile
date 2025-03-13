import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:golden_thailand/data/models/response_models/product_model.dart';
import 'package:golden_thailand/service/products_service.dart';

part 'product_crud_state.dart';

class ProductCrudCubit extends Cubit<ProductCrudState> {
  final ProductService productService;
  ProductCrudCubit({required this.productService})
      : super(ProductCrudInitial());

  ///add new product
  Future<bool> addNewProduct({required ProductModel product}) async {
    emit(ProductLoading());
    try {
      bool status = await productService.addNewProduct(
        url: "product/store",
        requestBody: product.toJson(),
      );
      if (status) {
        emit(ProductCreated());
        return true;
      } else {
        emit(ProductError());
        return false;
      }
    } catch (e) {
      emit(ProductError());
      return false;
    }
  }

  ///update product
  Future<bool> updateProduct(
      {required ProductModel product, required String id}) async {
    emit(ProductLoading());
    try {
      bool status = await productService.updateProduct(
        url: "product/edit/${id}",
        requestBody: product.toJson(),
      );
      if (status) {
        emit(ProductCreated());
        return true;
      } else {
        emit(ProductError());
        return false;
      }
    } catch (e) {
      emit(ProductError());
      return false;
    }
  }

  ///delete product
  Future<bool> deleteProduct({required String productId}) async {
    emit(ProductLoading());
    try {
      bool status = await productService.deleteProduct(
        url: "product/delete/${productId}",
        requestBody: {},
      );
      if (status) {
        emit(ProductDeleted());
        return true;
      } else {
        emit(ProductError());
        return false;
      }
    } catch (e) {
      emit(ProductError());
      return false;
    }
  }
}
