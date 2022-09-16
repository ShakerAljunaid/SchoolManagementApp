import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseProvider {
  static DatabaseProvider _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Data

  DatabaseProvider._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseProvider() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseProvider
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }
  //para evitar que abra varias conexciones una y otra vez podemos usar algo como esto..
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstanace();
    return _database;
  }

  List<String> generalDate() {
    List<String> generalTableList = new List();
    String schoolYears = "CREATE TABLE schoolYears ("
        "id integer PRIMARY KEY  ,"
        "cpId integer,"
        "guid text,"
        "yearTitle text ,"
        "yearSlogan text ,"
        "schoolId integer ,"
        "startsOn text,"
        "endsOn text,"
        "currentStatus integer,"
        "softDeleteState integer"
        ");";
    String schoolTerms = "CREATE TABLE schoolTerms ("
        "id integer PRIMARY KEY  ,"
        "cpId integer,"
        "guid text,"
        "termTitle text ,"
        "yearId integer ,"
        "schoolId integer ,"
        "startsOn text,"
        "endsOn text,"
        "currentStatus integer,"
        "softDeleteState integer"
        ");";

    String schoolTermRounds = "CREATE TABLE schoolTermRounds ("
        "id integer PRIMARY KEY  ,"
        "cpId integer,"
        "guid text,"
        "roundTitle text ,"
        "yearId integer ,"
        "termId integer,"
        "schoolId integer ,"
        "startsOn text,"
        "endsOn text,"
        "currentStatus integer,"
        "completeStatus integer,"
        "softDeleteState integer"
        ");";
    String examTable = "CREATE TABLE examTable ("
        "id integer PRIMARY KEY  ,"
        "cpId integer,"
        "guid text,"
        "roundId integer ,"
        "yearId integer ,"
        "termId integer ,"
        "schoolId integer ,"
        "classId integer ,"
        "gradeId integer ,"
        "branchId integer ,"
        "subjectId integer ,"
        "subjectName text,"
        "dueDate text,"
        "requirements text,"
        "softDeleteState integer"
        ");";

    generalTableList
        .addAll({schoolTerms, schoolYears, schoolTermRounds, examTable});
    return generalTableList;
  }

  List<String> studentTables() {
    List<String> studentTableList = new List();

    String studentAccount = "CREATE TABLE studentAccounts ("
        "id integer PRIMARY KEY  ,"
        "guid text,"
        "accountId integer ,"
        "parentAccountId integer ,"
        "name text ,"
        "schoolId integer ,"
        "classId integer,"
        "gradeId integer,"
        "branchId integer,"
        "yearId integer,"
        "termId integer,"
        "schoolName text ,"
        "className text ,"
        "gradeName text ,"
        "branchName text ,"
        "yearName text ,"
        "termName text ,"
        "code text"
        ");";
    String studentSubjects = "CREATE TABLE studentSubjects ("
        "id integer PRIMARY KEY  ,"
        "cpId integer,"
        "guid text,"
        "teacherName text ,"
        "subjectName text ,"
        "schoolId integer ,"
        "classId integer,"
        "gradeId integer,"
        "branchId integer,"
        "yearId integer,"
        "termId integer,"
        "softDeleteState integer"
        ");";

    String studentMarks = "CREATE TABLE studentMarks ("
        "id integer PRIMARY KEY  ,"
        "cpId integer,"
        "guid text,"
        "markTypeId integer,"
        "markTypeName  text,"
        "subjectName text,"
        "markValue real,"
        "subjectId integer,"
        "schoolId integer ,"
        "classId integer,"
        "gradeId integer,"
        "branchId integer,"
        "yearId integer,"
        "termId integer,"
        "studentId integer,"
        "roundId integer,"
        "notes text,"
        "softDeleteState integer"
        ");";

    // String studentTasksContainer = "CREATE TABLE studentTasksContainers ("
    //     "id integer PRIMARY KEY  ,"
    //     "cpId integer,"
    //     "guid text,"
    //     "subjectId integer ,"
    //     "taskName text ,"
    //     "taskItem text ,"
    //     "taskDate text ,"
    //     "schoolId integer ,"
    //     "classId integer,"
    //     "gradeId integer,"
    //     "branchId integer,"
    //     "yearId integer,"
    //     "termId integer,"
    //     "softDeleteState integer"
    //     ");";
    String studentTasksItems = "CREATE TABLE studentTasksItems ("
        "id integer PRIMARY KEY  ,"
        "cpId integer,"
        "guid text,"
        "taskContainerId integer ,"
        "taskItem text ,"
        "sortNo integer ,"
        "schoolId integer ,"
        "classId integer,"
        "gradeId integer,"
        "branchId integer,"
        "yearId integer,"
        "termId integer,"
        "completeStatus integer default 0,"
        "softDeleteState integer"
        ");";
    String timeTable = "CREATE TABLE timeTable ("
        "id integer PRIMARY KEY  ,"
        "cpId integer,"
        "guid text,"
        "subjectId integer ,"
        "dayName text ,"
        "teacherName text ,"
        "lectureTime text ,"
        "schoolId integer ,"
        "classId integer,"
        "gradeId integer,"
        "branchId integer,"
        "yearId integer,"
        "termId integer,"
        "softDeleteState integer"
        ");";
    String messages = "CREATE TABLE messages ("
        "id integer PRIMARY KEY ,"
        "cpId integer,"
        "guid text,"
        "gradeId integer,"
        "classId integer,"
        "branchId integer,"
        "yearId integer,"
        "schoolId integer ,"
        "termId integer,"
        "typeId integer,"
        "title text,"
        "content text,"
        "sendingDate text,"
        "senderName text,"
        "senderId integer,"
        "receiverId integer,"
        "isSynched integer DEFAULT 0, "
        "readOrNot integer DEFAULT 0,"
        "softDeleteState integer DEFAULT 0"
        ");";

    studentTableList.addAll({
      studentAccount,
      studentSubjects,
      studentMarks,
      studentTasksItems,
      timeTable,
      messages
    });

    return studentTableList;
  }

  Future<Database> getDatabaseInstanace() async {
    String path = '';

    path = join(await getDatabasesPath(), 'ajialalsafaschool.db');

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      //Create tables of the data pulled from MIS
      for (var stdDt in studentTables()) await db.execute(stdDt);
      for (var gndDt in generalDate()) await db.execute(gndDt);
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      if (oldVersion < newVersion) {
        // try {
        //   for (var nwTblDt in newTablesAfter6Vr()) await db.execute(nwTblDt);
        //   //  final dir = Directory(path);
        //   // dir.deleteSync(recursive: true);
        // } catch (e) {
        //   print(e);
        // }
      }
    });
  }
}
