import 'package:bloc/bloc.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/data/models/response_models/expense_model.dart';
import 'package:golden_thailand/service/expense_service.dart';
import 'package:meta/meta.dart';

part 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  final ExpenseService expenseService;
  ExpenseCubit({required this.expenseService})
      : super(ExpenseInitial());

  ///to get all the categories
  Future getAllExpense() async {
    emit(ExpenseLoadingState());
    String code = await getLocalizationKey();
    try {
      List<ExpenseModel> expense = await expenseService.getAllExpenses(
        requestBody: {},
        url: "cost?language=$code",
      );

      emit(ExpenseLoadedState(ExpenseList: expense));
    } catch (e) {
      emit(ExpenseErrorState(error: e.toString()));
    }
  }
}
