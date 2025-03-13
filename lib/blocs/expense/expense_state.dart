part of 'expense_cubit.dart';

@immutable
sealed class ExpenseState {}

final class ExpenseInitial extends ExpenseState {}

final class ExpenseLoadingState extends ExpenseState {}


final class ExpenseLoadedState extends ExpenseState {
  final List<ExpenseModel> ExpenseList;
  ExpenseLoadedState({required this.ExpenseList});
}

final class ExpenseErrorState extends ExpenseState {
  final String error;
  ExpenseErrorState({required this.error});
}