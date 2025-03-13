part of 'menu_type_cubit.dart';

@immutable
sealed class MenuTypeState {}

final class MenuTypeInitial extends MenuTypeState {}

final class MenuTypeLoading extends MenuTypeState {}

final class MenuTypeLoaded extends MenuTypeState {
  final List<MenuTypeModel> menuTypeList;
  MenuTypeLoaded({required this.menuTypeList});
}

final class MenuTypeError extends MenuTypeState {
  final String error;
  MenuTypeError({required this.error});
}
