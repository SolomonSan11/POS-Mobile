import 'package:bloc/bloc.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/data/models/response_models/sale_history_model.dart';
import 'package:golden_thailand/service/history_service.dart';
import 'package:meta/meta.dart';
part 'sales_history_state.dart';

class SalesHistoryCubit extends Cubit<SalesHistoryState> {
  final HistoryService historyService;

  SalesHistoryCubit({required this.historyService})
      : super(SalesHistoryInitial());

  ///get history list by pagination
  Future<void> getHistoryByPagination({required int page}) async {
    emit(SalesHistoryLoadingState());
    String code = await getLocalizationKey();
    try {
      List<SaleHistoryModel> historyList =
          await historyService.getHistoriesByPagination(
        requestBody: {},
        url: "sale/lists?page=${page}&language=$code",
      );

      emit(SalesHistoryLoadedState(history: historyList));
    } catch (e) {
      emit(SalesHistoryErrorState(error: 'Failed to fetch sales history: $e'));
    }
  }

  ///search history
  void searchHistory({required String query}) async {
    emit(SalesHistoryLoadingState());
    String code = await getLocalizationKey();
    try {
      List<SaleHistoryModel> historyList =
          await historyService.searchSaleHistory(
        requestBody: {"slip_number": query},
        url: "sale/search?order_no=${query}&language=$code",
      );

      emit(SalesHistoryLoadedState(history: historyList));
    } catch (e) {
      emit(SalesHistoryErrorState(error: 'Failed to fetch sales history: $e'));
    }
  }

  Future<bool> deleteHistory({required String id}) async {
    emit(SalesHistoryLoadingState());
    try {
      bool status = await historyService.deleteHistory(
        url: "sale/delete/${id}",
        requestBody: {},
      );
      if (status) {
        emit(SalesHistoryDeleted());
        return true;
      } else {
        emit(SalesHistoryErrorState(error: 'Failed to fetch sales history'));
        return false;
      }
    } catch (e) {
      emit(SalesHistoryErrorState(error: 'Failed to fetch sales history: $e'));
      return false;
    }
  }

  ///load more history list
  Future<bool> loadMoreHistory({
    required Map<String, dynamic> requestBody,
    required int page,
  }) async {
    try {
      List<SaleHistoryModel> moreHistories =
          await historyService.getHistoriesByPagination(
        url: "sale/lists?page=${page}",
        requestBody: requestBody,
      );

      SalesHistoryState currentState = state;

      if (currentState is SalesHistoryLoadedState) {
        List<SaleHistoryModel> histories = currentState.history + moreHistories;
        emit(SalesHistoryLoadedState(
          history: histories,
        ));
      } else {
        emit(SalesHistoryErrorState(error: 'Invalid state'));
      }

      return moreHistories.isEmpty || moreHistories.length == 0 ? true : false;
    } catch (e) {
      emit(SalesHistoryErrorState(error: 'Failed to fetch more products: $e'));
      return false;
    }
  }
}
