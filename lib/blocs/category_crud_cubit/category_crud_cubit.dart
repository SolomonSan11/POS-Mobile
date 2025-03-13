import 'package:bloc/bloc.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:meta/meta.dart';
import 'package:golden_thailand/service/category_service.dart';

part 'category_crud_state.dart';

class CategoryCrudCubit extends Cubit<CategoryCrudState> {
  final CategoryService categoryService;

  CategoryCrudCubit({required this.categoryService})
      : super(CategoryCrudInitial());

  ///create category
  Future<bool> createCategory({required String categoryName}) async {
    String code = await getLocalizationKey();
    emit(CategoryLoading());
    try {
      bool status = await categoryService.createCategory(
        url: "category/store",
        requestBody: {
          "name": categoryName,
          "language":code
        },
      );
      if (status) {
        emit(CategoryCreated());
        return true;
      } else {
        emit(CategoryError());
        return false;
      }
    } catch (e) {
      emit(CategoryError());
      return false;
    }
  }

  ///delete category
  Future<bool> deleteCategory({required String id}) async {
    emit(CategoryLoading());
    try {
      bool status = await categoryService.deleteCategory(
        url: "category/delete/${id}",
        requestBody: {},
      );
      if (status) {
        emit(CategoryDeleted());
        return true;
      } else {
        emit(CategoryError());
        return false;
      }
    } catch (e) {
      emit(CategoryError());
      return false;
    }
  }

  ///update category
  Future<bool> updateCategory({
    required String id,
    required String name,
    required String description,
  }) async {
    emit(CategoryLoading());
    try {
      bool status = await categoryService.updateCategory(
        url: "category/edit/${id}",
        requestBody: {"name": "${name}", "description": "${description}"},
      );
      if (status) {
        emit(CategoryUpdated());
        return true;
      } else {
        emit(CategoryError());
        return false;
      }
    } catch (e) {
      emit(CategoryError());
      return false;
    }
  }
}
