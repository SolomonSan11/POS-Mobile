import 'package:bloc/bloc.dart';
import 'package:golden_thailand/data/models/response_models/sale_record_model.dart';
import 'package:golden_thailand/service/expense_report_service.dart';
import 'package:meta/meta.dart';

part 'sale_record_state.dart';

class SaleRecordCubit extends Cubit<SaleRecordState> {
  final ExpenseReportService expenseReportService;
  SaleRecordCubit({required this.expenseReportService}) : super(SaleRecordInitial());

  ///get sale record list
  void getSaleRecordList() async {
    emit(SaleRecordLoading());
    try {
      List<SaleRecordModel> saleReport = await expenseReportService.getSaleRecordWithDate(
        url: "sale-record",
      );
      emit(SaleRecordLoaded(saleRecordModel: saleReport));
    } catch (e) {
      emit(SaleRecordError());
    }
  }
}
