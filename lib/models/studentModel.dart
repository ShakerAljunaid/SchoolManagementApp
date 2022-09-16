class StudentModel {
  int id,
      accountId,
      parentAccountId,
      schoolId,
      classId,
      gradeId,
      branchId,
      yearId,
      termId;
  String guid,
      name,
      schoolName,
      className,
      gradeName,
      branchName,
      yearName,
      termName,
      code;

  StudentModel(
      {this.id,
      this.accountId,
      this.parentAccountId,
      this.schoolId,
      this.classId,
      this.gradeId,
      this.branchId,
      this.yearId,
      this.termId,
      this.guid,
      this.name,
      this.schoolName,
      this.className,
      this.gradeName,
      this.branchName,
      this.yearName,
      this.termName,
      this.code});

  //To insert the data in the bd, we need to convert it into a Map
  //Para insertar los datos en la bd, necesitamos convertirlo en un Map
  Map<String, dynamic> toMap() => {
        'id': id,
        'accountId': accountId,
        'parentAccountId': parentAccountId,
        'schoolId': schoolId,
        'classId': classId,
        'gradeId': gradeId,
        'branchId': branchId,
        'yearId': yearId,
        'termId': termId,
        'guid': guid,
        'name': name,
        'className': className,
        'gradeName': gradeName,
        'branchName': branchName,
        'code': code,
      };

  //to receive the data we need to pass it from Map to json
  //para recibir los datos necesitamos pasarlo de Map a json
  factory StudentModel.fromMap(Map<String, dynamic> json) => new StudentModel(
        id: json['id'],
        accountId: json['accountId'],
        parentAccountId: json['parentAccountId'],
        schoolId: json['schoolId'],
        classId: json['classId'],
        gradeId: json['gradeId'],
        branchId: json['branchId'],
        yearId: json['yearId'],
        termId: json['termId'],
        guid: json['guid'],
        name: json['name'],
        schoolName: json['schoolName'],
        className: json['className'],
        gradeName: json['gradeName'],
        branchName: json['branchName'],
        yearName: json['yearName'],
        termName: json['termName'],
        code: json['code'],
      );
}
