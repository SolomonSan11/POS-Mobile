part of 'category_cubit.dart';

sealed class CategoriesState {}

final class CategoriesInitial extends CategoriesState {}

final class CategoriesLoadingState extends CategoriesState {}


final class CategoriesLoadedState extends CategoriesState {
  final List<CategoryModel> categoriesList;
  CategoriesLoadedState({required this.categoriesList});
}

final class CategoriesErrorState extends CategoriesState {
  final String error;
  CategoriesErrorState({required this.error});
}

