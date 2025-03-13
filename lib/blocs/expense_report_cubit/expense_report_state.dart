part of 'expense_report_cubit.dart';

@immutable
sealed class ExpenseReportState {}

final class ExpenseReportInitial extends ExpenseReportState {}

final class ExpenseReportLoading extends ExpenseReportState {}

final class ExpenseReportDaily extends ExpenseReportState {
  final ExpenseReportModel expenseReport;
  ExpenseReportDaily({required this.expenseReport});
}

final class ExpenseReportWeekly extends ExpenseReportState {
  final ExpenseReportModel expenseReport;
  ExpenseReportWeekly({required this.expenseReport});
}

final class ExpenseReportMonthly extends ExpenseReportState {
  final ExpenseReportModel currentMonthSale;
  ExpenseReportMonthly({
    required this.currentMonthSale,
  });
}

final class ExpenseReportError extends ExpenseReportState {}
