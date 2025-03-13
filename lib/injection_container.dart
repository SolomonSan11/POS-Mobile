
import 'package:golden_thailand/blocs/expense/expense_cubit.dart';
import 'package:golden_thailand/blocs/expense_crud_cubit/expense_crud_cubit.dart';
import 'package:golden_thailand/blocs/expense_report_cubit/expense_report_cubit.dart';
import 'package:golden_thailand/blocs/menu_type_cubit/menu_type_cubit.dart';
import 'package:golden_thailand/blocs/payment_api/payment_api_cubit.dart';
import 'package:golden_thailand/blocs/sale_record_cubit/sale_record_cubit.dart';
import 'package:golden_thailand/blocs/table_cubit/table_cubit.dart';
import 'package:golden_thailand/blocs/auth_cubit/auth_cubit.dart';
import 'package:golden_thailand/blocs/edit_sale_cart_cubit/edit_sale_cart_cubit.dart';
import 'package:golden_thailand/blocs/cart_cubit/cart_cubit.dart';
import 'package:golden_thailand/blocs/category_crud_cubit/category_crud_cubit.dart';
import 'package:golden_thailand/blocs/category_cubit/category_cubit.dart';
import 'package:golden_thailand/blocs/internet_connection_bloc/internet_connection_bloc.dart';
import 'package:golden_thailand/blocs/pending_order_cubit/pending_order_cubit.dart';
import 'package:golden_thailand/blocs/product_crud_cubit/product_crud_cubit.dart';
import 'package:golden_thailand/blocs/products_cubit/products_cubit.dart';
import 'package:golden_thailand/blocs/sale_process_cubit/sale_process_cubit.dart';
import 'package:golden_thailand/blocs/sale_report_cubit/sale_report_cubit.dart';
import 'package:golden_thailand/blocs/sales_history_cubit/sales_history_cubit.dart';
import 'package:golden_thailand/core/share_prefs.dart';
import 'package:golden_thailand/data/api/base_api.dart';
import 'package:golden_thailand/service/expense_service.dart';
import 'package:golden_thailand/service/auth_service.dart';
import 'package:golden_thailand/service/category_service.dart';
import 'package:golden_thailand/service/expense_report_service.dart';
import 'package:golden_thailand/service/history_service.dart';
import 'package:golden_thailand/service/menu_type_service.dart';
import 'package:golden_thailand/service/payment_api_service.dart';
import 'package:golden_thailand/service/products_service.dart';
import 'package:golden_thailand/service/report_service.dart';
import 'package:golden_thailand/service/sale_service.dart';
import 'package:golden_thailand/service/table_service.dart';
import 'package:golden_thailand/service/version_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

///primary initializiation for primary app∏
void primaryInit() {
  //blocs / cubits
  getIt.registerFactory(() => InternetConnectionBloc());
  getIt.registerFactory(() => AuthCubit(authService: getIt.call(), sharedPref: getIt.call()));
  getIt.registerFactory(() => ProductsCubit(productService: getIt.call()));
  getIt.registerFactory(() => CartCubit());
  getIt.registerFactory(() => CategoriesCubit(categoryService: getIt.call()));
  getIt.registerFactory(() => SaleProcessCubit(saleService: getIt.call()));
  getIt.registerFactory(() => SalesHistoryCubit(historyService: getIt.call()));
  getIt.registerFactory(() => CategoryCrudCubit(categoryService: getIt.call()));
  getIt.registerFactory(() => ExpenseCrudCubit(expenseService: getIt.call()));
  getIt.registerFactory(() => ExpenseCubit(expenseService: getIt.call()));
  getIt.registerFactory(() => ProductCrudCubit(productService: getIt.call()));
  // getIt.registerFactory(() => RemarkCubit(remarkService: getIt.call()));
  getIt.registerFactory(() => TableCubit(tableService: getIt.call()));
  getIt.registerFactory(() => SaleReportCubit(reportService: getIt.call()));
  getIt.registerFactory(() => EditSaleCartCubit());
  getIt.registerFactory(() => PendingOrderCubit(sharedPref: getIt.call()));
  getIt.registerFactory(() => PaymentApiCubit(paymentApiService: getIt.call()));
  getIt.registerFactory(() => MenuTypeCubit(menuTypeService: getIt.call()));
  getIt.registerFactory(() => ExpenseReportCubit(expenseReportService: getIt.call()));
  getIt.registerFactory(() => SaleRecordCubit(expenseReportService: getIt.call()));

  //services
  getIt.registerLazySingleton(() => AuthService(baseApi: getIt.call()));
  getIt.registerLazySingleton(() => ProductService(baseApi: getIt.call()));
  getIt.registerLazySingleton(() => CategoryService(baseApi: getIt.call()));
  getIt.registerLazySingleton(() => ExpenseService(baseApi: getIt.call()));
  getIt.registerLazySingleton(() => SaleService(baseApi: getIt.call()));
  getIt.registerLazySingleton(() => HistoryService(baseApi: getIt.call()));
  getIt.registerLazySingleton(() => VersionService(baseApi: getIt.call()));
  // getIt.registerLazySingleton(() => RemarkService(baseApi: getIt.call()));
  getIt.registerLazySingleton(() => TableService(baseApi: getIt.call()));
  getIt.registerLazySingleton(() => MenuTypeService(baseApi: getIt.call()));
  getIt.registerLazySingleton(() => ReportService(baseApi: getIt.call()));
  getIt.registerLazySingleton(() => PaymentApiService(baseApi: getIt.call()));
  getIt.registerLazySingleton(() => ExpenseReportService(baseApi: getIt.call()));

  //base api
  getIt.registerLazySingleton(() => BaseApi(sharedPref: getIt.call()));

  //shared pref
  getIt.registerLazySingleton(() => SharedPref());
}

