part of 'payment_api_cubit.dart';

@immutable
sealed class PaymentApiState {}

final class PaymentApiInitial extends PaymentApiState {}

final class PaymentApiLoading extends PaymentApiState {}

final class PaymentApiLoaded extends PaymentApiState {
  final PaymentModel paymentModel;
  PaymentApiLoaded({required this.paymentModel});
}

final class PaymentApiError extends PaymentApiState {}
