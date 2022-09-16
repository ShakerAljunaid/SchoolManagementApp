import 'dart:convert';

import 'package:ajialalsafaschool/models/GeneralClasses/NetworkCheck.dart';
import 'package:ajialalsafaschool/models/GeneralClasses/dialogs_alerts.dart';
import 'package:ajialalsafaschool/models/examTableModel.dart';
import 'package:ajialalsafaschool/models/messageModel.dart';
import 'package:ajialalsafaschool/models/roundModel.dart';
import 'package:ajialalsafaschool/models/studentMarksModel.dart';
import 'package:ajialalsafaschool/models/studentModel.dart';
import 'package:ajialalsafaschool/models/termModel.dart';
import 'package:ajialalsafaschool/models/yearModel.dart';
import 'package:ajialalsafaschool/services/examTable/examTable_db_operations.dart';
import 'package:ajialalsafaschool/services/messages/messages_db_operations.dart';
import 'package:ajialalsafaschool/services/rounds/rounds_db_operations.dart';
import 'package:ajialalsafaschool/services/studentMarks/studentMarks_db_operations.dart';
import 'package:ajialalsafaschool/services/students/students_db_operations.dart';
import 'package:ajialalsafaschool/services/terms/terms_db_operations.dart';
import 'package:ajialalsafaschool/services/years/years_db_operations.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'dart:async';

import 'package:requests/requests.dart';

class FetchData {
  var cpUrl = 'https://192.168.1.35:44386';
  void showSyncPane(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.update(
      progress: 50.0,
      message: "...جاري رفع البيانات",
      progressWidget: Container(
          padding: EdgeInsets.all(7.0), child: CircularProgressIndicator()),
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    pr.show();
  }

  ProgressDialog pr;

  Future<StudentModel> fetchAllStudentData(
      BuildContext context, int studentCode) async {
    StudentModel studentModel;

    if (await NetworkCheck().checkInternetConnection()) {
      try {
        await Requests.post(cpUrl + "/Students/ListStudentByCode",
                timeoutSeconds: 120,
                body: {"code": studentCode},
                bodyEncoding: RequestBodyEncoding.FormURLEncoded)
            .then((v) async {
          var tablesData = json.decode(v.content());
          print(tablesData);
          if (v.json() != null) {
            for (var s in tablesData[0]['student']) {
              studentModel = StudentModel.fromMap(s);
              await StudentDatabaseOperation.studentDbOprPrv
                  .syncStudentsData(studentModel);
            }

            List<YearModel> yearsModel = new List();
            for (var y in tablesData[0]['year']) {
              var yr = YearModel.fromMap(y);
              yearsModel.add(yr);
            }
            yearsModel.length > 0
                ? await YearDatabaseOperation.yearDbOprPrv
                    .syncYearsData(yearsModel)
                : print('');

            List<TermModel> shcoolTerms = new List();
            for (var t in tablesData[0]['terms']) {
              var tr = TermModel.fromMap(t);
              shcoolTerms.add(tr);
            }
            shcoolTerms.length > 0
                ? await TermDatabaseOperation.termDbOprPrv
                    .syncTermssData(shcoolTerms)
                : print('');

            List<RoundModel> shcoolRounds = new List();
            for (var r in tablesData[0]['rounds']) {
              var tr = RoundModel.fromMap(r);
              shcoolRounds.add(tr);
            }
            shcoolRounds.length > 0
                ? await RoundDatabaseOperation.roundDbOprPrv
                    .syncroundssData(shcoolRounds)
                : print('');

            List<ExamTableModel> roundExamTable = new List();
            for (var et in tablesData[0]['examTable']) {
              var e = ExamTableModel.fromMap(et);
              roundExamTable.add(e);
            }
            roundExamTable.length > 0
                ? await ExamTableDatabaseOperation.examTableDbOprPrv
                    .syncexamTablessData(roundExamTable)
                : print('');

            List<StudentMarksModel> studentMarks = new List();
            for (var m in tablesData[0]['marks']) {
              var mr = StudentMarksModel.fromMap(m);
              studentMarks.add(mr);
            }
            studentMarks.length > 0
                ? await StudentMarksDatabaseOperation.studentMarksDbOprPrv
                    .syncstudentMarksData(studentMarks)
                : print('');
          } else {
            await DialogsAlerts.dialogsAlerts
                .wrongAlert(context, 'خطأ', 'الرجاء التأكد من البيانات!');
          }
        });
      } catch (error) {
        print(error);
        await DialogsAlerts.dialogsAlerts
            .wrongAlert(context, 'خطأ غير معروف', "الرجاء التأكد من البيانات");
      }
    } else {
      await DialogsAlerts.dialogsAlerts
          .wrongAlert(context, 'خطأ', 'الرجاء التحقق من وجود انترنت!');
    }
    return studentModel;
  }

  Future<StudentModel> fetchStudentData(
      BuildContext context, String studentCode) async {
    StudentModel studentModel;

    if (await NetworkCheck().checkInternetConnection()) {
      try {
        await Requests.post(cpUrl + "/Students/ListStudentData",
                timeoutSeconds: 120,
                body: {"code": studentCode},
                bodyEncoding: RequestBodyEncoding.FormURLEncoded)
            .then((v) async {
          var tablesData = json.decode(v.content());
          print(tablesData);
          if (v.json() != null) {
            for (var s in tablesData) {
              studentModel = StudentModel.fromMap(s);
              await StudentDatabaseOperation.studentDbOprPrv
                  .syncStudentsData(studentModel);
            }
          } else {
            await DialogsAlerts.dialogsAlerts
                .wrongAlert(context, 'خطأ', 'الرجاء التأكد من البيانات!');
          }
        });
      } catch (error) {
        print(error);
        await DialogsAlerts.dialogsAlerts
            .wrongAlert(context, 'خطأ غير معروف', "الرجاء التأكد من البيانات");
      }
    } else {
      await DialogsAlerts.dialogsAlerts
          .wrongAlert(context, 'خطأ', 'الرجاء التحقق من وجود انترنت!');
    }
    return studentModel;
  }

  Future<YearModel> fetchYearData(BuildContext context, int schoolId,
      int branchId, int gradeId, int classId, int studentId) async {
    YearModel yearModel;

    if (await NetworkCheck().checkInternetConnection()) {
      try {
        await Requests.post(cpUrl + "/SchoolYears/List",
                timeoutSeconds: 120,
                body: {
                  "schoolId": schoolId,
                  "branchId": branchId,
                  "gradeId": gradeId,
                  "classId": classId,
                  "studentId": studentId
                },
                bodyEncoding: RequestBodyEncoding.FormURLEncoded)
            .then((v) async {
          var tablesData = json.decode(v.content());
          print(tablesData);
          if (v.json() != null) {
            List<YearModel> years = new List.empty();
            for (var s in tablesData) {
              yearModel = YearModel.fromMap(s);
              years.add(yearModel);
            }
            await YearDatabaseOperation.yearDbOprPrv.syncYearsData(years);
          } else {
            await DialogsAlerts.dialogsAlerts
                .wrongAlert(context, 'خطأ', 'الرجاء التأكد من البيانات!');
          }
        });
      } catch (error) {
        print(error);
        await DialogsAlerts.dialogsAlerts
            .wrongAlert(context, 'خطأ غير معروف', "الرجاء التأكد من البيانات");
      }
    } else {
      await DialogsAlerts.dialogsAlerts
          .wrongAlert(context, 'خطأ', 'الرجاء التحقق من وجود انترنت!');
    }
    return yearModel;
  }

  Future<bool> fetchTermData(BuildContext context, int schoolId, int branchId,
      int gradeId, int classId, int studentId, int yearId) async {
    bool fetchState = false;

    if (await NetworkCheck().checkInternetConnection()) {
      try {
        await Requests.post(cpUrl + "/SchoolTerms/ListTermsBaseOnYears",
                timeoutSeconds: 120,
                body: {
                  "schoolId": schoolId,
                  "branchId": branchId,
                  "gradeId": gradeId,
                  "classId": classId,
                  "studentId": studentId,
                  "yearId": yearId
                },
                bodyEncoding: RequestBodyEncoding.FormURLEncoded)
            .then((v) async {
          var tablesData = json.decode(v.content());
          print(tablesData);
          if (v.json() != null) {
            List<TermModel> terms = new List.empty();

            for (var s in tablesData) {
              var t = TermModel.fromMap(s);
              terms.add(t);
            }
            TermDatabaseOperation.termDbOprPrv
                .syncTermssData(terms)
                .then((value) {
              fetchState = true;
            });
          } else {
            await DialogsAlerts.dialogsAlerts
                .wrongAlert(context, 'خطأ', 'الرجاء التأكد من البيانات!');
          }
        });
      } catch (error) {
        print(error);
        await DialogsAlerts.dialogsAlerts
            .wrongAlert(context, 'خطأ غير معروف', "الرجاء التأكد من البيانات");
      }
    } else {
      await DialogsAlerts.dialogsAlerts
          .wrongAlert(context, 'خطأ', 'الرجاء التحقق من وجود انترنت!');
    }
    return fetchState;
  }

  Future<bool> fetchRoundsData(BuildContext context, int schoolId, int branchId,
      int gradeId, int classId, int studentId, int yearId, int termId) async {
    bool fetchState = false;

    if (await NetworkCheck().checkInternetConnection()) {
      try {
        await Requests.post(cpUrl + "/TermsRounds/ListRoundsBasedOnTerms",
                timeoutSeconds: 120,
                body: {
                  "schoolId": schoolId,
                  "branchId": branchId,
                  "gradeId": gradeId,
                  "classId": classId,
                  "studentId": studentId,
                  "yearId": yearId,
                  "termId": termId
                },
                bodyEncoding: RequestBodyEncoding.FormURLEncoded)
            .then((v) async {
          var tablesData = json.decode(v.content());
          print(tablesData);
          if (v.json() != null) {
            List<RoundModel> rounds = new List.empty();
            for (var rnd in tablesData) {
              var r = RoundModel.fromMap(rnd);
              rounds.add(r);
            }
            RoundDatabaseOperation.roundDbOprPrv
                .syncroundssData(rounds)
                .then((value) {
              fetchState = true;
            });
          } else {
            await DialogsAlerts.dialogsAlerts
                .wrongAlert(context, 'خطأ', 'الرجاء التأكد من البيانات!');
          }
        });
      } catch (error) {
        print(error);
        await DialogsAlerts.dialogsAlerts
            .wrongAlert(context, 'خطأ غير معروف', "الرجاء التأكد من البيانات");
      }
    } else {
      await DialogsAlerts.dialogsAlerts
          .wrongAlert(context, 'خطأ', 'الرجاء التحقق من وجود انترنت!');
    }
    return fetchState;
  }

  Future<bool> fetchMarksData(BuildContext context, int schoolId, int branchId,
      int gradeId, int classId, int studentId, int yearId, int termId) async {
    bool fetchState = false;

    if (await NetworkCheck().checkInternetConnection()) {
      try {
        await Requests.post(cpUrl + "/StudentMarks/ListStudentMarsk",
                timeoutSeconds: 120,
                body: {
                  "schoolId": schoolId,
                  "branchId": branchId,
                  "gradeId": gradeId,
                  "classId": classId,
                  "studentId": studentId,
                  "yearId": yearId,
                  "termId": termId
                },
                bodyEncoding: RequestBodyEncoding.FormURLEncoded)
            .then((v) async {
          var tablesData = json.decode(v.content());
          print(tablesData);
          if (v.json() != null) {
            List<StudentMarksModel> studentMarks = new List();
            for (var sm in tablesData) {
              var m = StudentMarksModel.fromMap(sm);
              studentMarks.add(m);
            }
            StudentMarksDatabaseOperation.studentMarksDbOprPrv
                .syncstudentMarksData(studentMarks)
                .then((value) {
              fetchState = true;
            });
          } else {
            await DialogsAlerts.dialogsAlerts
                .wrongAlert(context, 'خطأ', 'الرجاء التأكد من البيانات!');
          }
        });
      } catch (error) {
        print(error);
        await DialogsAlerts.dialogsAlerts
            .wrongAlert(context, 'خطأ غير معروف', "الرجاء التأكد من البيانات");
      }
    } else {
      await DialogsAlerts.dialogsAlerts
          .wrongAlert(context, 'خطأ', 'الرجاء التحقق من وجود انترنت!');
    }
    return fetchState;
  }

  Future<bool> fetchExamTableData(
      BuildContext context,
      int schoolId,
      int branchId,
      int gradeId,
      int classId,
      int studentId,
      int yearId,
      int termId) async {
    bool fetchState = true;

    if (await NetworkCheck().checkInternetConnection()) {
      try {
        await Requests.post(cpUrl + "/ExamTables/ListExamTablesBasedOnGrade",
                timeoutSeconds: 120,
                body: {
                  "schoolId": schoolId,
                  "branchId": branchId,
                  "gradeId": gradeId,
                  "classId": classId,
                  "studentId": studentId,
                  "yearId": yearId,
                  "termId": termId
                },
                bodyEncoding: RequestBodyEncoding.FormURLEncoded)
            .then((v) async {
          var tablesData = json.decode(v.content());
          print(tablesData);
          if (v.json() != null) {
            List<ExamTableModel> examTables = new List();
            for (var et in tablesData) {
              var e = ExamTableModel.fromMap(et);
              examTables.add(e);
            }
            ExamTableDatabaseOperation.examTableDbOprPrv
                .syncexamTablessData(examTables)
                .then((value) {
              fetchState = true;
            });
          } else {
            await DialogsAlerts.dialogsAlerts
                .wrongAlert(context, 'خطأ', 'الرجاء التأكد من البيانات!');
          }
        });
      } catch (error) {
        print(error);
        fetchState = false;
        await DialogsAlerts.dialogsAlerts
            .wrongAlert(context, 'خطأ غير معروف', "الرجاء التأكد من البيانات");
      }
    } else {
      fetchState = false;
      await DialogsAlerts.dialogsAlerts
          .wrongAlert(context, 'خطأ', 'الرجاء التحقق من وجود انترنت!');
    }
    return fetchState;
  }

  Future<bool> fetchMessagesData(
      BuildContext context,
      int schoolId,
      int branchId,
      int gradeId,
      int classId,
      int studentId,
      int yearId,
      int termId) async {
    bool fetchState = false;

    if (await NetworkCheck().checkInternetConnection()) {
      try {
        await Requests.post(cpUrl + "/Messages/ListMessagesBaseOnGrade",
                timeoutSeconds: 120,
                body: {
                  "schoolId": schoolId,
                  "branchId": branchId,
                  "gradeId": gradeId,
                  "classId": classId,
                  "studentId": studentId,
                  "yearId": yearId,
                  "termId": termId
                },
                bodyEncoding: RequestBodyEncoding.FormURLEncoded)
            .then((v) async {
          var tablesData = json.decode(v.content());
          print(tablesData);
          if (v.json() != null) {
            List<MessageModel> messages = List.empty();
            for (var mt in tablesData) {
              var m = MessageModel.fromMap(mt);
              messages.add(m);
            }
            MessagesDatabaseOperations.msgDb
                .syncMsgsData(messages)
                .then((value) {
              fetchState = true;
            });
          } else {
            await DialogsAlerts.dialogsAlerts
                .wrongAlert(context, 'خطأ', 'الرجاء التأكد من البيانات!');
          }
        });
      } catch (error) {
        print(error);
        await DialogsAlerts.dialogsAlerts
            .wrongAlert(context, 'خطأ غير معروف', "الرجاء التأكد من البيانات");
      }
    } else {
      await DialogsAlerts.dialogsAlerts
          .wrongAlert(context, 'خطأ', 'الرجاء التحقق من وجود انترنت!');
    }
    return fetchState;
  }
}
