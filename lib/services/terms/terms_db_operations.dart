import 'package:ajialalsafaschool/models/termModel.dart';
import 'package:ajialalsafaschool/services/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:uuid/uuid.dart';

class TermDatabaseOperation {
  TermDatabaseOperation._();
  DatabaseProvider dbPrv = new DatabaseProvider();
  static final TermDatabaseOperation termDbOprPrv = TermDatabaseOperation._();

  //Query
  //muestra todos los Beneficiaryes de la base de datos
  Future<List<TermModel>> getAllterms(int schoolId) async {
    final db = await dbPrv.database;

    var response = await db.query("schoolTerms",
        where: " schoolId=?  and currentStatus=1 and softDeleteState!=1",
        whereArgs: [schoolId]);
    List<TermModel> list = response.map((c) => TermModel.fromMap(c)).toList();
    return list;
  }

  Future<List<TermModel>> getActiveYearterms(int schoolId, int yearId) async {
    final db = await dbPrv.database;

    var response = await db.rawQuery(
        "select t.* from schoolTerms t join schoolYears y on y.id=t.yearId where  y.currentStatus=1 and y.softDeleteState!=1 and t.currentStatus=1 and t.softDeleteState!=1 and t.schoolId=$schoolId and t.yearId=$yearId");
    List<TermModel> list = response.map((c) => TermModel.fromMap(c)).toList();

    for (var r in list) {
      var noOfRounds = await db.rawQuery(
          "SELECT count(id) as noOfRounds FROM schoolTermRounds where  termId=${r.id}");
      r.noOfRounds = noOfRounds.first["noOfRounds"];
      var noOfCompletedRounds = await db.rawQuery(
          "SELECT count(id) as noOfCompletedRounds FROM schoolTermRounds where  termId=${r.id} and CompleteStatus=1");

      r.noOfCompletedRounds = noOfCompletedRounds.first["noOfCompletedRounds"];
    }
    List<TermModel> itemsWithofList =
        list.where((r) => r.noOfRounds > 0).toList();
    return itemsWithofList;
  }

  Future<List<TermModel>> syncTermssData(List<TermModel> terms) async {
    final db = await dbPrv.database;
    var response = await db.query("schoolTerms",
        where: " schoolId=? and yearId=? ",
        whereArgs: [terms[0].schoolId, terms[0].yearId]);
    List<TermModel> list = response.map((c) => TermModel.fromMap(c)).toList();
    for (int i = 0; i < terms.length; i++) {
      var rowState = list.firstWhere((dropdown) => dropdown.id == terms[i].id,
          orElse: () => null);
      if (rowState == null)
        addtermModelToDatabase(terms[i]);
      else {
        terms[i].id = rowState.id;
        updatetermModel(terms[i]);
      }
    }
    return list;
  }

  //Insert
  addtermModelToDatabase(TermModel termModel) async {
    final db = await dbPrv.database;
    termModel..guid = Uuid().v4();
    var raw = await db.insert(
      "schoolTerms",
      termModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  //Delete
  //Delete beneficiarytodos with id
  deletetermModelWithId(int id) async {
    final db = await dbPrv.database;
    return db.delete("schoolTerms", where: "id = ?", whereArgs: [id]);
  }

  //Delete all beneficiarytodos
  deleteAlltermModel() async {
    final db = await dbPrv.database;
    db.delete("schoolTerms");
  }

  //Update
  updatetermModel(TermModel termModel) async {
    final db = await dbPrv.database;

    var response = await db.update("schoolTerms", termModel.toMap(),
        where: "id = ?", whereArgs: [termModel.id]);
    return response;
  }
}
