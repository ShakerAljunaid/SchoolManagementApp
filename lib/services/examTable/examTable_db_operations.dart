import 'package:ajialalsafaschool/models/examTableModel.dart';
import 'package:ajialalsafaschool/services/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:uuid/uuid.dart';

class ExamTableDatabaseOperation {
  ExamTableDatabaseOperation._();
  DatabaseProvider dbPrv = new DatabaseProvider();
  static final ExamTableDatabaseOperation examTableDbOprPrv =
      ExamTableDatabaseOperation._();

  //Query
  //muestra todos los Beneficiaryes de la base de datos
  Future<List<ExamTableModel>> getAllexamTables(int schoolId) async {
    final db = await dbPrv.database;

    var response = await db.query("examTable",
        where: " schoolId=?  and currentStatus=1 and softDeleteState!=1",
        whereArgs: [schoolId]);
    List<ExamTableModel> list =
        response.map((c) => ExamTableModel.fromMap(c)).toList();
    return list;
  }

  Future<List<ExamTableModel>> getActiveYearexamTables(
      int schoolId, int yearId, int termId, int roundId) async {
    final db = await dbPrv.database;

    var response = await db.rawQuery(
        "select e.* from examTable e join schoolYears y on y.id=e.yearId where  y.currentStatus=1 and y.softDeleteState!=1 and  e.softDeleteState!=1 and e.schoolId=$schoolId and e.yearId=$yearId and e.termId=$termId and e.roundId=$roundId");
    List<ExamTableModel> list =
        response.map((c) => ExamTableModel.fromMap(c)).toList();
    return list;
  }

  Future<List<ExamTableModel>> syncexamTablessData(
      List<ExamTableModel> examTables) async {
    final db = await dbPrv.database;
    var response = await db.query("examTable",
        where: " schoolId=? and yearId=? ",
        whereArgs: [examTables[0].schoolId, examTables[0].yearId]);
    List<ExamTableModel> list =
        response.map((c) => ExamTableModel.fromMap(c)).toList();
    for (int i = 0; i < examTables.length; i++) {
      var rowState = list.firstWhere(
          (dropdown) => dropdown.id == examTables[i].id,
          orElse: () => null);
      if (rowState == null)
        addExamTableModelToDatabase(examTables[i]);
      else {
        examTables[i].id = rowState.id;
        updateExamTableModel(examTables[i]);
      }
    }
    return list;
  }

  //Insert
  addExamTableModelToDatabase(ExamTableModel examTableModel) async {
    final db = await dbPrv.database;
    examTableModel.guid = Uuid().v4();
    var raw = await db.insert(
      "examTable",
      examTableModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  //Delete
  //Delete beneficiarytodos with id
  deleteExamTableModelWithId(int id) async {
    final db = await dbPrv.database;
    return db.delete("examTable", where: "id = ?", whereArgs: [id]);
  }

  //Delete all beneficiarytodos
  deleteAllExamTableModel() async {
    final db = await dbPrv.database;
    db.delete("examTable");
  }

  //Update
  updateExamTableModel(ExamTableModel examTableModel) async {
    final db = await dbPrv.database;

    var response = await db.update("examTable", examTableModel.toMap(),
        where: "id = ?", whereArgs: [examTableModel.id]);
    return response;
  }
}
