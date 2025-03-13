import 'package:bloc/bloc.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/data/models/response_models/product_model.dart';
import 'package:golden_thailand/service/products_service.dart';
import 'package:meta/meta.dart';
part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductService productService;

  ProductsCubit({required this.productService}) : super(ProductsInitial());

  ///get all products by pagination
  Future getAllProducts() async {
    String code = await getLocalizationKey();
    emit(ProductsLoadingState());
    try {
      List<ProductModel> products = await productService.getAllProducts(
        url: "product?language=$code",
        requestBody: {},
      );

      emit(ProductsLoadedState(products: products));
    } catch (e) {
      emit(ProductsErrorState(error: 'Failed to fetch sales products : ${e}'));
    }
  }

  ///get all products by category
  // getProductsByCategory({
  //   required Map<String, dynamic> requestBody,
  //   required int categoryId,
  // }) async {
  //   emit(ProductsLoadingState());

  //   try {
  //     List<ProductModel> products = await productService.getProductsByCategory(
  //       // url: "api/user/category/product/${categoryId}",
  //       url: "category/by-product/${categoryId}",
  //       requestBody: requestBody,
  //     );

  //     emit(ProductsLoadedState(products: products));
  //   } catch (e) {
  //     emit(ProductsErrorState(error: 'getProductsByCategory : ${e}'));
  //   }
  // }

  ///load products by category
  // Future<bool> loadMoreProductsByCategory({
  //   required Map<String, dynamic> requestBody,
  //   required int categoryId,
  // }) async {
  //   try {
  //     List<ProductModel> moreProducts =
  //         await productService.getPrdoductsByPagination(
  //       url: "api/user/category/product/${categoryId}",
  //       requestBody: requestBody,
  //     );

  //     ProductsState currentState = state;

  //     if (currentState is ProductsLoadedState) {
  //       List<ProductModel> allProducts = currentState.products + moreProducts;
  //       emit(ProductsLoadedState(products: allProducts));
  //     } else {
  //       emit(ProductsErrorState(error: 'Invalid state'));
  //     }

  //     return moreProducts.isEmpty || moreProducts.length == 0 ? true : false;
  //   } catch (e) {
  //     emit(ProductsErrorState(error: 'Failed to fetch more products: $e'));
  //     return false;
  //   }
  // }

  ///load all products without category
  // Future<bool> loadMoreProducts({
  //   required Map<String, dynamic> requestBody,
  // }) async {
  //   try {
  //     List<ProductModel> moreProducts =
  //         await productService.getPrdoductsByPagination(
  //       url: "api/user/product",
  //       requestBody: requestBody,
  //     );

  //     ProductsState currentState = state;

  //     if (currentState is ProductsLoadedState) {
  //       List<ProductModel> allProducts = currentState.products + moreProducts;
  //       emit(ProductsLoadedState(products: allProducts));
  //     } else {
  //       emit(ProductsErrorState(error: 'Invalid state'));
  //     }

  //     return moreProducts.isEmpty || moreProducts.length == 0 ? true : false;
  //   } catch (e) {
  //     emit(ProductsErrorState(error: 'Failed to fetch more products: $e'));
  //     return false;
  //   }
  // }
}
