import 'package:bloc/bloc.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/data/models/menu_type_model.dart';
import 'package:golden_thailand/service/menu_type_service.dart';
import 'package:meta/meta.dart';
part 'menu_type_state.dart';

class MenuTypeCubit extends Cubit<MenuTypeState> {
  final MenuTypeService menuTypeService;

  MenuTypeCubit({required this.menuTypeService}) : super(MenuTypeInitial());

  ///get all products by pagination
  getMenuTypeData() async {
    String code = await getLocalizationKey();
    emit(MenuTypeLoading());
    try {
      List<MenuTypeModel> levels = await menuTypeService.getMenuTypeList(
        url: "menu-type?language=$code",
      );

      emit(MenuTypeLoaded(menuTypeList: levels));
    } catch (e) {
      emit(MenuTypeError(error: e.toString()));
    }
  }
}
