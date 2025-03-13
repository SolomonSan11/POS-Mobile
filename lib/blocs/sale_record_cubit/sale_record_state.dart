part of 'sale_record_cubit.dart';

@immutable
sealed class SaleRecordState {}

final class SaleRecordInitial extends SaleRecordState {}
final class SaleRecordLoading extends SaleRecordState {}
final class SaleRecordLoaded extends SaleRecordState {
  List<SaleRecordModel> saleRecordModel = [];
  SaleRecordLoaded({required this.saleRecordModel});
}
final class SaleRecordError extends SaleRecordState {
}
