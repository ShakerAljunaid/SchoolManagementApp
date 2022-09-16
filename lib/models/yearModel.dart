class YearModel {
  int id, cpId, schoolId, currentStatus, softDeleteState;
  String guid, yearTitle, yearSlogan, startsOn, endsOn;

  YearModel({
    this.id,
    this.cpId,
    this.schoolId,
    this.currentStatus,
    this.softDeleteState,
    this.guid,
    this.yearTitle,
    this.yearSlogan,
    this.startsOn,
    this.endsOn,
  });

  //To insert the data in the bd, we need to convert it into a Map
  //Para insertar los datos en la bd, necesitamos convertirlo en un Map
  Map<String, dynamic> toMap() => {
        'id': id,
        'cpId': cpId,
        'currentStatus': currentStatus,
        'schoolId': schoolId,
        'guid': guid,
        'softDeleteState': softDeleteState,
        'yearTitle': yearTitle,
        'yearSlogan': yearSlogan,
        'startsOn': startsOn,
        'endsOn': endsOn
      };

  //to receive the data we need to pass it from Map to json
  //para recibir los datos necesitamos pasarlo de Map a json
  factory YearModel.fromMap(Map<String, dynamic> json) => new YearModel(
        id: json['id'],
        cpId: json['cpId'],
        currentStatus: json['currentStatus'],
        schoolId: json['schoolId'],
        softDeleteState: json['softDeleteState'],
        guid: json['guid'],
        yearTitle: json['yearTitle'],
        yearSlogan: json['yearSlogan'],
        startsOn: json['startsOn'],
        endsOn: json['endsOn'],
      );
}
