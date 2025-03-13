
import 'package:golden_thailand/data/models/table_model.dart';

sealed class TableState {}

final class TableInitial extends TableState {}

final class TableLoading extends TableState {}

final class TableLoaded extends TableState {
  final List<TableModel> TableList;
  final List<TableModel> BuffetableList;
  TableLoaded({required this.TableList,required this.BuffetableList});
}

final class TableCreated extends TableState {}

final class TableDeleted extends TableState {}

final class TableError extends TableState {
  final String error;
  TableError({required this.error});
}

final class TableUpdated extends TableState {}

