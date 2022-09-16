import 'package:ajialalsafaschool/models/yearModel.dart';
import 'package:ajialalsafaschool/services/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:uuid/uuid.dart';

class YearDatabaseOperation {
  YearDatabaseOperation._();
  DatabaseProvider dbPrv = new DatabaseProvider();
  static final YearDatabaseOperation yearDbOprPrv = YearDatabaseOperation._();

  //Query
  //muestra todos los Beneficiaryes de la base de datos
  Future<List<YearModel>> getAllYears(int schoolId) async {
    final db = await dbPrv.database;
    var response = await db.query("schoolYears",
        where: " schoolId=?  and currentStatus=1 and softDeleteState!=1",
        whereArgs: [schoolId]);
    List<YearModel> list = response.map((c) => YearModel.fromMap(c)).toList();
    return list;
  }

  Future<List<YearModel>> syncYearsData(List<YearModel> years) async {
    final db = await dbPrv.database;
    var response = await db.query("schoolYears",
        where: " schoolId=?", whereArgs: [years[0].schoolId]);
    List<YearModel> list = response.map((c) => YearModel.fromMap(c)).toList();
    for (int i = 0; i < years.length; i++) {
      var rowState = list.firstWhere((dropdown) => dropdown.id == years[i].id,
          orElse: () => null);
      if (rowState == null)
        addYearModelToDatabase(years[i]);
      else {
        years[i].id = rowState.id;
        updateYearModel(years[i]);
      }
    }
    return list;
  }

  //Insert
  addYearModelToDatabase(YearModel yearModel) async {
    final db = await dbPrv.database;
    yearModel.guid = Uuid().v4();
    var raw = await db.insert(
      "schoolYears",
      yearModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  //Delete
  //Delete beneficiarytodos with id
  deleteYearModelWithId(int id) async {
    final db = await dbPrv.database;
    return db.delete("schoolYears", where: "id = ?", whereArgs: [id]);
  }

  //Delete all beneficiarytodos
  deleteAllYearModel() async {
    final db = await dbPrv.database;
    db.delete("schoolYears");
  }

  //Update
  updateYearModel(YearModel yearModel) async {
    final db = await dbPrv.database;

    var response = await db.update("schoolYears", yearModel.toMap(),
        where: "id = ?", whereArgs: [yearModel.id]);
    return response;
  }
}
