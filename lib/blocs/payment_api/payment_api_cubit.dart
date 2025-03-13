import 'package:bloc/bloc.dart';
import 'package:golden_thailand/data/models/response_models/payment_model.dart';
import 'package:golden_thailand/service/payment_api_service.dart';
import 'package:meta/meta.dart';

part 'payment_api_state.dart';

class PaymentApiCubit extends Cubit<PaymentApiState> {
  final PaymentApiService paymentApiService;
  PaymentApiCubit({required this.paymentApiService})
      : super(PaymentApiInitial());

  ///get data
  Future<PaymentModel?> getData() async {
    emit(PaymentApiLoading());
    try {
      List<PaymentModel> data = await paymentApiService
          .getPaymentData(url: "payment-type", requestBody: {});
      emit(PaymentApiLoaded(paymentModel: data[0]));
      return data[0];
    } catch (e) {
      emit(PaymentApiError());
      return null;
    }
  }
}
