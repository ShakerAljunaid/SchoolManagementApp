import 'package:ajialalsafaschool/models/GeneralClasses/shared_prf_data.dart';
import 'package:ajialalsafaschool/models/studentModel.dart';
import 'package:ajialalsafaschool/services/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:uuid/uuid.dart';

class StudentDatabaseOperation {
  StudentDatabaseOperation._();
  DatabaseProvider dbPrv = new DatabaseProvider();
  static final StudentDatabaseOperation studentDbOprPrv =
      StudentDatabaseOperation._();

  //Query
  //muestra todos los Beneficiaryes de la base de datos
  Future<List<StudentModel>> getAllStudents() async {
    final db = await dbPrv.database;
    var usertData = await getSharedPref();
    var response = await db.query("studentAccounts",
        where: "parentAccountId=? and schoolId=?  ",
        whereArgs: [usertData.id, usertData.schoolId]);
    List<StudentModel> list =
        response.map((c) => StudentModel.fromMap(c)).toList();
    return list;
  }

  syncStudentsData(StudentModel student) async {
    final db = await dbPrv.database;
    var response = await db
        .query("studentAccounts", where: "id=?", whereArgs: [student.id]);
    return response.isNotEmpty
        ? updateStudentModel(student)
        : addStudentModelToDatabase(student);
  }

  //Insert
  addStudentModelToDatabase(StudentModel studentModel) async {
    final db = await dbPrv.database;
    studentModel.guid = Uuid().v4();
    var raw = await db.insert(
      "studentAccounts",
      studentModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  //Delete
  //Delete beneficiarytodos with id
  deleteStudentModelWithId(int id) async {
    final db = await dbPrv.database;
    return db.delete("studentAccounts", where: "id = ?", whereArgs: [id]);
  }

  //Delete all beneficiarytodos
  deleteAllStudentModel() async {
    final db = await dbPrv.database;
    db.delete("studentAccounts");
  }

  //Update
  updateStudentModel(StudentModel studentModel) async {
    final db = await dbPrv.database;
    var usertData = await getSharedPref();
    studentModel.parentAccountId = usertData.id;
    var response = await db.update("studentAccounts", studentModel.toMap(),
        where: "id = ?", whereArgs: [studentModel.id]);
    return response;
  }
}
