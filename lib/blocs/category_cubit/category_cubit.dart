import 'package:bloc/bloc.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/data/models/response_models/category_model.dart';
import 'package:golden_thailand/service/category_service.dart';
part 'category_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final CategoryService categoryService;

  CategoriesCubit({required this.categoryService})
      : super(CategoriesInitial());

  ///to get all the categories
  Future getAllCategories() async {
    emit(CategoriesLoadingState());
    String code = await getLocalizationKey();
    try {
      List<CategoryModel> categories = await categoryService.getAllCategories(
        requestBody: {},
        url: "category?language=$code",
      );

      emit(CategoriesLoadedState(categoriesList: categories));
    } catch (e) {
      emit(CategoriesErrorState(error: e.toString()));
    }
  }
}

