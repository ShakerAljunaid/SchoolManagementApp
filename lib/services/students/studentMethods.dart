import 'dart:convert';

import 'package:ajialalsafaschool/models/GeneralClasses/NetworkCheck.dart';
import 'package:ajialalsafaschool/models/GeneralClasses/dialogs_alerts.dart';
import 'package:ajialalsafaschool/models/GeneralClasses/shared_prf_data.dart';
import 'package:ajialalsafaschool/models/studentModel.dart';
import 'package:ajialalsafaschool/models/roundModel.dart';
import 'package:ajialalsafaschool/models/examTableModel.dart';
import 'package:ajialalsafaschool/models/studentMarksModel.dart';
import 'package:ajialalsafaschool/models/termModel.dart';
import 'package:ajialalsafaschool/models/yearModel.dart';
import 'package:ajialalsafaschool/services/examTable/examTable_db_operations.dart';
import 'package:ajialalsafaschool/services/rounds/rounds_db_operations.dart';
import 'package:ajialalsafaschool/services/studentMarks/studentMarks_db_operations.dart';
import 'package:ajialalsafaschool/services/students/students_db_operations.dart';
import 'package:ajialalsafaschool/services/terms/terms_db_operations.dart';
import 'package:ajialalsafaschool/services/years/years_db_operations.dart';
import 'package:flutter/material.dart';
import 'package:requests/requests.dart';

class StudentMethods {
  StudentMethods._();
  static final StudentMethods studentMtd = StudentMethods._();

  Future<StudentModel> addStudent(BuildContext context, String code) async {
    StudentModel studentModel;
    if (await NetworkCheck().checkInternetConnection()) {
      try {
        var usertData = await getSharedPref();
        await Requests.post(
                "https://192.168.1.35:44386/Students/ListStudentByCode",
                timeoutSeconds: 120,
                body: {"code": code},
                bodyEncoding: RequestBodyEncoding.FormURLEncoded)
            .then((v) async {
          var tablesData = json.decode(v.content());
          print(tablesData);
          if (v.json() != null) {
            for (var s in tablesData[0]['student']) {
              studentModel = StudentModel.fromMap(s);
              studentModel.parentAccountId = usertData.id;
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
}
