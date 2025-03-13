import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/data/models/request_models/sale_request_model.dart';
import 'package:golden_thailand/service/sale_service.dart';
import 'package:meta/meta.dart';
part 'sale_process_state.dart';

class SaleProcessCubit extends Cubit<SaleProcessState> {
  final SaleService saleService;

  SaleProcessCubit({required this.saleService}) : super(SaleProcessInitial());

  ///make Sale old
  Future<bool> makeSale({
    required Map<String,dynamic> saleRequest,
  }) async {
    emit(SaleProcessLoadingState());

    print("sale request : ${jsonEncode(saleRequest)}");

    try {
      bool saleResponse = await saleService.makeSale(
        url: "sale",
        requestBody: saleRequest,
      );

      if (saleResponse) {
        emit(SaleProcessSuccessState());
        return true;
      } else {
        return false;
      }
    } catch (e) {
      emit(SaleProcessFailedState(error: 'make Sale(Cubit) : ${e}'));
      return false;
    }
  }

  ///make Sale old
  Future<bool> updateSale({
    required SaleModel saleRequest,
    required final String orderId,
  }) async {
    emit(SaleProcessLoadingState());

    print("sale request : ${jsonEncode(saleRequest.toMap())}");
    String code = await getLocalizationKey();
    try {
      bool saleResponse = await saleService.makeSale(
        url: "sale/list/${orderId}?language=$code",
        requestBody: saleRequest.toMap(),
      );

      if (saleResponse) {
        emit(SaleProcessSuccessState());
        return true;
      } else {
        return false;
      }
    } catch (e) {
      emit(SaleProcessFailedState(error: 'make Sale(Cubit) : ${e}'));
      return false;
    }
  }
  // ///make Sale old
  // Future<SaleResponseModel?> makeSale({
  //   required SaleModel saleRequest,
  // }) async {
  //   emit(SaleProcessLoadingState());

  //   SaleResponseModel? saleResponseModel;

  //   print("sale request : ${jsonEncode(saleRequest.toMap())}");

  //   try {
  //     SaleResponseModel? saleResponse = await saleService.makeSale(
  //         url: "sale", requestBody: saleRequest.toMap());

  //     saleResponseModel = saleResponse;

  //     emit(SaleProcessSuccessState(saleResponse: saleResponse));
  //   } catch (e) {
  //     emit(SaleProcessFailedState(error: 'make Sale(Cubit) : ${e}'));
  //   }
  //   return saleResponseModel;
  // }
}
