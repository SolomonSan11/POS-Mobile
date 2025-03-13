part of 'category_crud_cubit.dart';

@immutable
sealed class CategoryCrudState {}

final class CategoryCrudInitial extends CategoryCrudState {}

final class CategoryLoading extends CategoryCrudState {}

final class CategoryCreated extends CategoryCrudState {}

final class CategoryDeleted extends CategoryCrudState {}

final class CategoryError extends CategoryCrudState {}

final class CategoryUpdated extends CategoryCrudState {}
