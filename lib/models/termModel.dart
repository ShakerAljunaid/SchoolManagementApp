class TermModel {
  int id,
      cpId,
      yearId,
      schoolId,
      currentStatus,
      softDeleteState,
      noOfRounds,
      noOfCompletedRounds;
  String guid, termTitle, startsOn, endsOn;

  TermModel(
      {this.id,
      this.cpId,
      this.schoolId,
      this.yearId,
      this.currentStatus,
      this.softDeleteState,
      this.guid,
      this.termTitle,
      this.startsOn,
      this.endsOn,
      this.noOfRounds,
      this.noOfCompletedRounds});

  //To insert the data in the bd, we need to convert it into a Map
  //Para insertar los datos en la bd, necesitamos convertirlo en un Map
  Map<String, dynamic> toMap() => {
        'id': id,
        'cpId': cpId,
        'currentStatus': currentStatus,
        'schoolId': schoolId,
        'yearId': yearId,
        'guid': guid,
        'softDeleteState': softDeleteState,
        'termTitle': termTitle,
        'startsOn': startsOn,
        'endsOn': endsOn
      };

  //to receive the data we need to pass it from Map to json
  //para recibir los datos necesitamos pasarlo de Map a json
  factory TermModel.fromMap(Map<String, dynamic> json) => new TermModel(
      id: json['id'],
      cpId: json['cpId'],
      currentStatus: json['currentStatus'],
      schoolId: json['schoolId'],
      softDeleteState: json['softDeleteState'],
      yearId: json['yearId'],
      guid: json['guid'],
      termTitle: json['termTitle'],
      startsOn: json['startsOn'],
      endsOn: json['endsOn'],
      noOfRounds: json['noOfRounds'],
      noOfCompletedRounds: json['noOfCompletedRounds']);
}
