part of 'product_crud_cubit.dart';

@immutable
sealed class ProductCrudState {}

final class ProductCrudInitial extends ProductCrudState {}

final class ProductLoading extends ProductCrudState {}

final class ProductError extends ProductCrudState {}

final class ProductCreated extends ProductCrudState {}

final class ProductUpdatedd extends ProductCrudState {}

final class ProductDeleted extends ProductCrudState {}
