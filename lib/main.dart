import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/blocs/discount_cubit/discount_cubit.dart';
import 'package:golden_thailand/blocs/expense/expense_cubit.dart';
import 'package:golden_thailand/blocs/expense_crud_cubit/expense_crud_cubit.dart';
import 'package:golden_thailand/blocs/expense_report_cubit/expense_report_cubit.dart';
import 'package:golden_thailand/blocs/menu_type_cubit/menu_type_cubit.dart';
import 'package:golden_thailand/blocs/payment_api/payment_api_cubit.dart';
import 'package:golden_thailand/blocs/sale_record_cubit/sale_record_cubit.dart';
import 'package:golden_thailand/blocs/table_cubit/table_cubit.dart';
import 'package:golden_thailand/blocs/auth_cubit/auth_cubit.dart';
import 'package:golden_thailand/blocs/category_crud_cubit/category_crud_cubit.dart';
import 'package:golden_thailand/blocs/edit_sale_cart_cubit/edit_sale_cart_cubit.dart';
import 'package:golden_thailand/blocs/pending_order_cubit/pending_order_cubit.dart';
import 'package:golden_thailand/blocs/product_crud_cubit/product_crud_cubit.dart';
import 'package:golden_thailand/blocs/sale_report_cubit/sale_report_cubit.dart';
import 'package:golden_thailand/injection_container.dart' as ic;
import 'package:golden_thailand/blocs/cart_cubit/cart_cubit.dart';
import 'package:golden_thailand/blocs/category_cubit/category_cubit.dart';
import 'package:golden_thailand/blocs/internet_connection_bloc/internet_connection_bloc.dart';
import 'package:golden_thailand/blocs/products_cubit/products_cubit.dart';
import 'package:golden_thailand/blocs/sale_process_cubit/sale_process_cubit.dart';
import 'package:golden_thailand/blocs/sales_history_cubit/sales_history_cubit.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/ui/pages/home.dart';
import 'package:golden_thailand/core/app_theme_const.dart';
import 'package:golden_thailand/ui/pages/auth/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  ic.primaryInit();
  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en', ''),
        Locale('my', ''),
        Locale('th', ''),
      ],
      fallbackLocale: Locale('en', ''),
      path: 'assets/translations',
      child: MyApp(),
    ),
  );
}

/**
 * Main display
 */
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final bool isLogin = true;
  bool openApp = false;
  bool? testingValue;
  String errorReason = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ic.getIt<InternetConnectionBloc>()),
        BlocProvider(create: (context) => ic.getIt<AuthCubit>()..checkLoginStatus()),
        BlocProvider(create: (context) => ic.getIt<CartCubit>()),
        BlocProvider(create: (context) => ic.getIt<ProductsCubit>()),
        BlocProvider(create: (context) => ic.getIt<CategoriesCubit>()),
        BlocProvider(create: (context) => ic.getIt<ExpenseCubit>()),
        BlocProvider(create: (context) => ic.getIt<SaleProcessCubit>()),
        BlocProvider(create: (context) => ic.getIt<SalesHistoryCubit>()),
        BlocProvider(create: (context) => ic.getIt<CategoryCrudCubit>()),
        BlocProvider(create: (context) => ic.getIt<ExpenseCrudCubit>()),
        BlocProvider(create: (context) => ic.getIt<ProductCrudCubit>()),
        BlocProvider(create: (context) => ic.getIt<TableCubit>()),
        BlocProvider(create: (context) => ic.getIt<SaleReportCubit>()),
        BlocProvider(create: (context) => ic.getIt<EditSaleCartCubit>()),
        BlocProvider(create: (context) => ic.getIt<PendingOrderCubit>()),
        BlocProvider(create: (context) => ic.getIt<PaymentApiCubit>()),
        BlocProvider(create: (context) => ic.getIt<MenuTypeCubit>()),
        BlocProvider(create: (context)=>DiscountCubit()..getNumbers()),
        BlocProvider(create: (context)=>ic.getIt<ExpenseReportCubit>()),
        BlocProvider(create: (context)=>ic.getIt<SaleRecordCubit>())

      ],
      child: MaterialApp(
        title: 'POS',
        theme: myTheme,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        home: MainDisplay(),
      ),
    );
  }
}

///MAIN DISPLAY
class MainDisplay extends StatelessWidget {
  const MainDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is ShopLoggedInState) {
            Future.delayed(
              Duration(seconds: 3),
              () {
                redirectTo(
                  context: context,
                  form: HomeScreen(),
                  replacement: true,
                );
              },
            );
          } else {
            Future.delayed(
              Duration(seconds: 3),
              () {
                redirectTo(
                  context: context,
                  form: Login(),
                  replacement: true,
                );
              },
            );
          }
        },
        builder: (context, state) {
          return Container(
            color: SScolor.primaryColor,
            child: Center(
              child: Container(
                height: 200,
                width: 200,
                child: Image.asset("assets/images/transparent_logo.png"),
              ),
            ),
          );
        },
      ),
    );
  }
}
