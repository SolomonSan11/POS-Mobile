import 'package:bloc/bloc.dart';
import 'package:golden_thailand/blocs/table_cubit/table_state.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/data/models/table_model.dart';
import 'package:golden_thailand/service/table_service.dart';

class TableCubit extends Cubit<TableState> {
  
  final TableService tableService;


  TableCubit({required this.tableService}) : super(TableInitial());

  ///addNewTable
  Future<bool> addNewTable(
      {required String levelName,required int menuTypeId}) async {
    emit(TableLoading());
    try {
      bool status = await tableService.addNewTable(
        url: "table/store",
        requestBody: {
          "number": levelName,
          "menu_type_id":menuTypeId
        },
      );
      if (status) {
        emit(TableCreated());
        return true;
      } else {
        emit(TableError(error: "Something is wrong!"));
        return false;
      }
    } catch (e) {
      emit(TableError(error: e.toString()));
      return false;
    }
  }

  ///delete category
  Future<bool> deleteTable({required String id}) async {
    emit(TableLoading());
    try {
      bool status = await tableService.deleteTable(
        url: "table/delete/${id}",
        requestBody: {},
      );
      if (status) {
        emit(TableDeleted());
        return true;
      } else {
        emit(TableError(error: "Something is wrong!"));
        return false;
      }
    } catch (e) {
      emit(TableError(error: e.toString()));
      return false;
    }
  }

  ///update category
  Future<bool> editTable({
    required String id,
    required String name,
    required String description,
  }) async {
    emit(TableLoading());
    try {
      bool status = await tableService.editTable(
        url: "table/edit/${id}",
        requestBody: {"name": "${name}", "description": "${description}"},
      );
      if (status) {
        emit(TableUpdated());
        return true;
      } else {
        emit(TableError(error: "Something is wrong!"));
        return false;
      }
    } catch (e) {
      emit(TableError(error: e.toString()));
      return false;
    }
  }

  ///get all products by pagination
  getAllLevels() async {
    emit(TableLoading());
    String code = await getLocalizationKey();
    try {
      List<TableModel> levels = await tableService.getTableList(
        url: "table?language=$code",
      );

      emit(TableLoaded(TableList: levels, BuffetableList: []));
    } catch (e) {
      emit(TableError(error: e.toString()));
    }
  }


}
