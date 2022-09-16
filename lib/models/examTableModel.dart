class ExamTableModel {
  int id,
      cpId,
      yearId,
      schoolId,
      roundId,
      classId,
      gradeId,
      branchId,
      subjectId,
      termId,
      softDeleteState;

  String guid, subjectName, dueDate, requirements;

  ExamTableModel({
    this.id,
    this.cpId,
    this.yearId,
    this.schoolId,
    this.roundId,
    this.classId,
    this.gradeId,
    this.branchId,
    this.subjectId,
    this.termId,
    this.softDeleteState,
    this.guid,
    this.subjectName,
    this.dueDate,
    this.requirements,
  });

  //To insert the data in the bd, we need to convert it into a Map
  //Para insertar los datos en la bd, necesitamos convertirlo en un Map
  Map<String, dynamic> toMap() => {
        'id': id,
        'cpId': cpId,
        'yearId': yearId,
        'schoolId': schoolId,
        'roundId': roundId,
        'classId': classId,
        'gradeId': gradeId,
        'branchId': branchId,
        'subjectId': subjectId,
        'termId': termId,
        'softDeleteState': softDeleteState,
        'guid': guid,
        'subjectName': subjectName,
        'dueDate': dueDate,
        'requirements': requirements,
      };

  //to receive the data we need to pass it from Map to json
  //para recibir los datos necesitamos pasarlo de Map a json
  factory ExamTableModel.fromMap(Map<String, dynamic> json) =>
      new ExamTableModel(
          id: json['id'],
          cpId: json['cpId'],
          yearId: json['yearId'],
          schoolId: json['schoolId'],
          roundId: json['roundId'],
          classId: json['classId'],
          gradeId: json['gradeId'],
          branchId: json['branchId'],
          subjectId: json['subjectId'],
          termId: json['termId'],
          softDeleteState: json['softDeleteState'],
          guid: json['guid'],
          subjectName: json['subjectName'],
          dueDate: json['dueDate'],
          requirements: json['requirements']);
}
