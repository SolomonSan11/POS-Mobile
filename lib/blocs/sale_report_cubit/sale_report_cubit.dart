import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:golden_thailand/data/models/sale_report_model.dart';
import 'package:golden_thailand/service/report_service.dart';

part 'sale_report_state.dart';

class SaleReportCubit extends Cubit<SaleReportState> {
  final ReportService reportService;
  SaleReportCubit({required this.reportService}) : super(SaleReportInitial());

  ///get daily reort data
  void getDailyReport() async {
    emit(SaleReportLoading());
    try {
      SaleReportModel saleReport = await reportService.getDailySail(
        url: "sale/daily",
      );
      emit(SaleReportDaily(saleReport: saleReport));
    } catch (e) {
      emit(SaleReportError());
    }
  }

  ///get daily reort data
  void getWeeklyReport() async {
    emit(SaleReportLoading());
    try {
      SaleReportModel saleReport = await reportService.getDailySail(
        url: "sale/weekly",
      );
      emit(SaleReportWeekly(saleReport: saleReport));
    } catch (e) {
      emit(SaleReportError());
    }
  }

  ///get montyly reort data
  void getMontylyReport() async {
    emit(SaleReportLoading());
    try {
      SaleReportModel? currentMonthSale = await reportService.getMontylySale(
        url: "sale/currentMonth",
      );
      SaleReportModel? pastMonthSale = await reportService.getMontylySale(
        url: "sale/pastMonth",
      );
      emit(SaleReportMonthly(
        lastMonthSale: pastMonthSale,
        currentMonthSale: currentMonthSale,
      ));
    } catch (e) {
      emit(SaleReportError());
    }
  }
}
