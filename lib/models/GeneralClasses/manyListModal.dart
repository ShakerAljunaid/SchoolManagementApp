class ManyListModal{
  int id,version,listTypeId,parentId,projectId,roundMapActivityId;

  String title;
 


  ManyListModal ({this.id, this.title,this.listTypeId,this.parentId,this.projectId,this.roundMapActivityId});

  //To insert the data in the bd, we need to convert it into a Map
  //Para insertar los datos en la bd, necesitamos convertirlo en un Map
  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "listTypeId":listTypeId,
    "parentId":parentId,
    "projectId":projectId,
    "roundMapActivityId":roundMapActivityId
  };

  //to receive the data we need to pass it from Map to json
  //para recibir los datos necesitamos pasarlo de Map a json
  factory ManyListModal.fromMap(Map<String, dynamic> json) => new ManyListModal(
     id: json["id"],
     title: json["title"],
     listTypeId: json["listTypeId"],
     projectId:json["projectId"],
     roundMapActivityId:json["roundMapActivityId"],
     parentId:json["parentId"]

     
    );
}