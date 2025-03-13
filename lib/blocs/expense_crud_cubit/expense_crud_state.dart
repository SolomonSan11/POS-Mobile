part of 'expense_crud_cubit.dart';

@immutable
sealed class ExpenseCrudState {}

final class ExpenseCrudInitial extends ExpenseCrudState {}

final class ExpenseLoading extends ExpenseCrudState {}

final class ExpenseCreated extends ExpenseCrudState {}

final class ExpenseDeleted extends ExpenseCrudState {}

final class ExpenseError extends ExpenseCrudState {}

final class ExpenseUpdated extends ExpenseCrudState {}
