class RoundModel {
  int id,
      cpId,
      yearId,
      schoolId,
      currentStatus,
      termId,
      softDeleteState,
      completeStatus;
  String guid, roundTitle, startsOn, endsOn;

  RoundModel({
    this.id,
    this.cpId,
    this.schoolId,
    this.yearId,
    this.termId,
    this.currentStatus,
    this.completeStatus,
    this.softDeleteState,
    this.guid,
    this.roundTitle,
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
        'yearId': yearId,
        'termId': termId,
        'guid': guid,
        'softDeleteState': softDeleteState,
        'completeStatus': completeStatus,
        'roundTitle': roundTitle,
        'startsOn': startsOn,
        'endsOn': endsOn
      };

  //to receive the data we need to pass it from Map to json
  //para recibir los datos necesitamos pasarlo de Map a json
  factory RoundModel.fromMap(Map<String, dynamic> json) => new RoundModel(
        id: json['id'],
        cpId: json['cpId'],
        currentStatus: json['currentStatus'],
        schoolId: json['schoolId'],
        termId: json['termId'],
        softDeleteState: json['softDeleteState'],
        completeStatus: json['completeStatus'],
        yearId: json['yearId'],
        guid: json['guid'],
        roundTitle: json['roundTitle'],
        startsOn: json['startsOn'],
        endsOn: json['endsOn'],
      );
}
