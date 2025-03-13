import 'package:bloc/bloc.dart';
import 'package:golden_thailand/data/models/expense_report_model.dart';
import 'package:golden_thailand/service/expense_report_service.dart';
import 'package:meta/meta.dart';

part 'expense_report_state.dart';

class ExpenseReportCubit extends Cubit<ExpenseReportState> {
  final ExpenseReportService expenseReportService;
  ExpenseReportCubit({required this.expenseReportService}) : super(ExpenseReportInitial());

  ///get daily reort data
  void getDailyReport() async {
    emit(ExpenseReportLoading());
    try {
      ExpenseReportModel ExpenseReport = await expenseReportService.getDailySail(
        url: "expense/daily",
      );
      emit(ExpenseReportDaily(expenseReport: ExpenseReport));
    } catch (e) {
      emit(ExpenseReportError());
    }
  }

  ///get daily reort data
  void getWeeklyReport() async {
    emit(ExpenseReportLoading());
    try {
      ExpenseReportModel ExpenseReport = await expenseReportService.getDailySail(
        url: "expense/weekly",
      );
      emit(ExpenseReportWeekly(expenseReport: ExpenseReport));
    } catch (e) {
      emit(ExpenseReportError());
    }
  }

  ///get montyly reort data
  void getMontylyReport() async {
    emit(ExpenseReportLoading());
    try {
      ExpenseReportModel? currentMonthSale = await expenseReportService.getMontylySale(
        url: "expense/monthly",
      );
   
      emit(ExpenseReportMonthly(
        currentMonthSale: currentMonthSale,
      ));
    } catch (e) {
      emit(ExpenseReportError());
    }
  }
}
