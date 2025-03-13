import 'package:bloc/bloc.dart';
import 'package:golden_thailand/core/api_const.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'discount_state.dart';

class DiscountCubit extends Cubit<DiscountState> {
  DiscountCubit() : super(DiscountState(numbers: 0));

  Future<void> createNumber(int number) async {
    final prefs = await SharedPreferences.getInstance();
     // String? storedNumbers =await prefs.getString(ApiConst.LOCAL_DISCOUNT_NUMBER) ;
      await prefs.setString(ApiConst.LOCAL_DISCOUNT_NUMBER, number.toString());
    print("check discount store or not :${await prefs.getString(ApiConst.LOCAL_DISCOUNT_NUMBER) }");
    emit(DiscountState(numbers: number));
  }

  Future<void> getNumbers() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedNumbers =await prefs.getString(ApiConst.LOCAL_DISCOUNT_NUMBER);
    print("dis one${await prefs.getString(ApiConst.LOCAL_DISCOUNT_NUMBER) }");
    emit(DiscountState(numbers: int.parse(storedNumbers??"0")));
  }

  Future<String> getValue() async {
    final prefs = await SharedPreferences.getInstance();
   String? storedNumbers =await prefs.getString(ApiConst.LOCAL_DISCOUNT_NUMBER);
   print("dis two ${await prefs.getString(ApiConst.LOCAL_DISCOUNT_NUMBER) }");
   return storedNumbers ?? "0";
  }

  Future<void> deleteNumbers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ApiConst.LOCAL_DISCOUNT_NUMBER, "0");
    // await prefs.remove(ApiConst.LOCAL_DISCOUNT_NUMBER);
    emit(DiscountState(numbers: 0));
  }
}
