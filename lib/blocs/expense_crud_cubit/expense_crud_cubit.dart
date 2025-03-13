import 'package:bloc/bloc.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/service/expense_service.dart';
import 'package:meta/meta.dart';

part 'expense_crud_state.dart';

class ExpenseCrudCubit extends Cubit<ExpenseCrudState> {
  final ExpenseService expenseService;

  ExpenseCrudCubit({required this.expenseService})
      : super(ExpenseCrudInitial());

  ///create Expense
  Future<bool> createExpense({required String ExpenseName,required int price,required int type, required int sale_record_id}) async {
    String code = await getLocalizationKey();
    emit(ExpenseLoading());
    try {
      bool status = await expenseService.createExpense(
        url: "cost/store",
        requestBody: {
          "name": ExpenseName,
          "price": price,
          "type":type,
          "sale_record_id":sale_record_id,
          "language":code
        },
      );
      if (status) {
        emit(ExpenseCreated());
        return true;
      } else {
        emit(ExpenseError());
        return false;
      }
    } catch (e) {
      emit(ExpenseError());
      return false;
    }
  }

  ///delete Expense
  Future<bool> deleteExpense({required String id}) async {
    emit(ExpenseLoading());
    try {
      bool status = await expenseService.deleteExpense(
        url: "cost/delete/${id}",
        requestBody: {},
      );
      if (status) {
        emit(ExpenseDeleted());
        return true;
      } else {
        emit(ExpenseError());
        return false;
      }
    } catch (e) {
      emit(ExpenseError());
      return false;
    }
  }

  ///update Expense
  Future<bool> updateExpense({
    required String id,
    required String name,
    required int price,
    required int type, required int sale_record_id
  }) async {
    String code = await getLocalizationKey();
    emit(ExpenseLoading());
    try {
      bool status = await expenseService.updateExpense(
        url: "cost/edit/${id}",
        requestBody: {"name": "${name}", "price": "${price}", "type":type,
          "sale_record_id":sale_record_id,
          "language":code},
      );
      if (status) {
        emit(ExpenseUpdated());
        return true;
      } else {
        emit(ExpenseError());
        return false;
      }
    } catch (e) {
      emit(ExpenseError());
      return false;
    }
  }
}
