import 'package:ajialalsafaschool/models/roundModel.dart';
import 'package:ajialalsafaschool/services/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:uuid/uuid.dart';

class RoundDatabaseOperation {
  RoundDatabaseOperation._();
  DatabaseProvider dbPrv = new DatabaseProvider();
  static final RoundDatabaseOperation roundDbOprPrv =
      RoundDatabaseOperation._();

  //Query
  //muestra todos los Beneficiaryes de la base de datos
  Future<List<RoundModel>> getAllrounds(int schoolId) async {
    final db = await dbPrv.database;

    var response = await db.query("schoolTermRounds",
        where: " schoolId=?  and currentStatus=1 and softDeleteState!=1",
        whereArgs: [schoolId]);
    List<RoundModel> list = response.map((c) => RoundModel.fromMap(c)).toList();
    return list;
  }

  Future<List<RoundModel>> getActiveYearrounds(
      int schoolId, int yearId, int termId) async {
    final db = await dbPrv.database;

    var response = await db.rawQuery(
        "select r.* from schoolTermRounds r join schoolYears y on y.id=r.yearId where  y.currentStatus=1 and y.softDeleteState!=1  and r.softDeleteState!=1 and r.schoolId=$schoolId and r.yearId=$yearId and r.termId=$termId");
    List<RoundModel> list = response.map((c) => RoundModel.fromMap(c)).toList();
    return list;
  }

  Future<List<RoundModel>> syncroundssData(List<RoundModel> rounds) async {
    final db = await dbPrv.database;
    var response = await db.query("schoolTermRounds",
        where: " schoolId=? and yearId=? ",
        whereArgs: [rounds[0].schoolId, rounds[0].yearId]);
    List<RoundModel> list = response.map((c) => RoundModel.fromMap(c)).toList();
    for (int i = 0; i < rounds.length; i++) {
      var rowState = list.firstWhere((dropdown) => dropdown.id == rounds[i].id,
          orElse: () => null);
      if (rowState == null)
        addRoundModelToDatabase(rounds[i]);
      else {
        rounds[i].id = rowState.id;
        updateRoundModel(rounds[i]);
      }
    }
    return list;
  }

  //Insert
  addRoundModelToDatabase(RoundModel roundModel) async {
    final db = await dbPrv.database;
    roundModel.guid = Uuid().v4();
    var raw = await db.insert(
      "schoolTermRounds",
      roundModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  //Delete
  //Delete beneficiarytodos with id
  deleteRoundModelWithId(int id) async {
    final db = await dbPrv.database;
    return db.delete("schoolTermRounds", where: "id = ?", whereArgs: [id]);
  }

  //Delete all beneficiarytodos
  deleteAllRoundModel() async {
    final db = await dbPrv.database;
    db.delete("schoolTermRounds");
  }

  //Update
  updateRoundModel(RoundModel roundModel) async {
    final db = await dbPrv.database;

    var response = await db.update("schoolTermRounds", roundModel.toMap(),
        where: "id = ?", whereArgs: [roundModel.id]);
    return response;
  }
}
