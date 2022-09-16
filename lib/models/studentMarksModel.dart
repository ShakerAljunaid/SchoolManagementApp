import 'dart:ffi';

class StudentMarksModel {
  int id,
      cpId,
      studentId,
      yearId,
      schoolId,
      roundId,
      classId,
      gradeId,
      branchId,
      subjectId,
      termId,
      markTypeId,
      softDeleteState;

  String guid, subjectName, notes, markTypeName;
  double markValue;

  StudentMarksModel(
      {this.id,
      this.cpId,
      this.yearId,
      this.schoolId,
      this.studentId,
      this.roundId,
      this.classId,
      this.gradeId,
      this.branchId,
      this.subjectId,
      this.termId,
      this.markTypeId,
      this.softDeleteState,
      this.guid,
      this.subjectName,
      this.notes,
      this.markTypeName,
      this.markValue});

  //To insert the data in the bd, we need to convert it into a Map
  //Para insertar los datos en la bd, necesitamos convertirlo en un Map
  Map<String, dynamic> toMap() => {
        'id': id,
        'cpId': cpId,
        'yearId': yearId,
        'schoolId': schoolId,
        'studentId': studentId,
        'roundId': roundId,
        'classId': classId,
        'gradeId': gradeId,
        'branchId': branchId,
        'subjectId': subjectId,
        'termId': termId,
        'markTypeId': markTypeId,
        'softDeleteState': softDeleteState,
        'guid': guid,
        'subjectName': subjectName,
        'notes': notes,
        'markTypeName': markTypeName,
        'markValue': markValue
      };

  //to receive the data we need to pass it from Map to json
  //para recibir los datos necesitamos pasarlo de Map a json
  factory StudentMarksModel.fromMap(Map<String, dynamic> json) =>
      new StudentMarksModel(
          id: json['id'],
          cpId: json['cpId'],
          yearId: json['yearId'],
          schoolId: json['schoolId'],
          studentId: json['studentId'],
          roundId: json['roundId'],
          classId: json['classId'],
          gradeId: json['gradeId'],
          branchId: json['branchId'],
          subjectId: json['subjectId'],
          termId: json['termId'],
          markTypeId: json['markTypeId'],
          softDeleteState: json['softDeleteState'],
          guid: json['guid'],
          subjectName: json['subjectName'],
          notes: json['notes'],
          markTypeName: json['markTypeName'],
          markValue: json['markValue']);
}
