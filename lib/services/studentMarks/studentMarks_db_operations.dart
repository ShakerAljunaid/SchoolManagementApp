import 'package:ajialalsafaschool/models/studentMarksModel.dart';
import 'package:ajialalsafaschool/services/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:uuid/uuid.dart';

class StudentMarksDatabaseOperation {
  StudentMarksDatabaseOperation._();
  DatabaseProvider dbPrv = new DatabaseProvider();
  static final StudentMarksDatabaseOperation studentMarksDbOprPrv =
      StudentMarksDatabaseOperation._();

  //Query
  //muestra todos los Beneficiaryes de la base de datos
  Future<List<StudentMarksModel>> getAllstudentMarkss(int schoolId) async {
    final db = await dbPrv.database;

    var response = await db.query("studentMarks",
        where: " schoolId=?  and currentStatus=1 and softDeleteState!=1",
        whereArgs: [schoolId]);
    List<StudentMarksModel> list =
        response.map((c) => StudentMarksModel.fromMap(c)).toList();
    return list;
  }

  Future<List<StudentMarksModel>> getSubjectsNames(
      int studentId, int schoolId, int yearId, int termId, int roundId) async {
    final db = await dbPrv.database;

    var response = await db.rawQuery(
        'select distinct sm.subjectName,sm.subjectId from studentMarks sm where sm.schoolId=$schoolId and sm.studentId=$studentId and sm.yearId=$yearId and sm.termId=$termId and sm.roundId=$roundId ');
    List<StudentMarksModel> list =
        response.map((c) => StudentMarksModel.fromMap(c)).toList();
    return list;
  }

  Future<List<StudentMarksModel>> getActiveYearstudentMarkss(
      int studentId, int schoolId, int yearId, int termId, int roundId) async {
    final db = await dbPrv.database;

    var response = await db.rawQuery(
        "select sm.* from studentMarks sm join schoolYears y on y.id=sm.yearId where  y.currentStatus=1 and y.softDeleteState!=1  and sm.softDeleteState!=1 and sm.studentId=$studentId and sm.schoolId=$schoolId and sm.yearId=$yearId and sm.termId=$termId and sm.roundId=$roundId");
    List<StudentMarksModel> list =
        response.map((c) => StudentMarksModel.fromMap(c)).toList();
    return list;
  }

  Future<List<StudentMarksModel>> syncstudentMarksData(
      List<StudentMarksModel> studentMarks) async {
    final db = await dbPrv.database;
    var response = await db.query("studentMarks",
        where: " schoolId=? and yearId=? ",
        whereArgs: [studentMarks[0].schoolId, studentMarks[0].yearId]);
    List<StudentMarksModel> list =
        response.map((c) => StudentMarksModel.fromMap(c)).toList();
    for (int i = 0; i < studentMarks.length; i++) {
      var rowState = list.firstWhere(
          (dropdown) => dropdown.id == studentMarks[i].id,
          orElse: () => null);
      if (rowState == null)
        addStudentMarksModelToDatabase(studentMarks[i]);
      else {
        studentMarks[i].id = rowState.id;
        updateStudentMarksModel(studentMarks[i]);
      }
    }
    return list;
  }

  //Insert
  addStudentMarksModelToDatabase(StudentMarksModel studentMarksModel) async {
    final db = await dbPrv.database;
    studentMarksModel.guid = Uuid().v4();
    var raw = await db.insert(
      "studentMarks",
      studentMarksModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  //Delete
  //Delete beneficiarytodos with id
  deleteStudentMarksModelWithId(int id) async {
    final db = await dbPrv.database;
    return db.delete("studentMarks", where: "id = ?", whereArgs: [id]);
  }

  //Delete all beneficiarytodos
  deleteAllStudentMarksModel() async {
    final db = await dbPrv.database;
    db.delete("studentMarks");
  }

  //Update
  updateStudentMarksModel(StudentMarksModel studentMarksModel) async {
    final db = await dbPrv.database;

    var response = await db.update("studentMarks", studentMarksModel.toMap(),
        where: "id = ?", whereArgs: [studentMarksModel.id]);
    return response;
  }
}
