class User {
  int id, schoolId, isActive, accountTypeId;
  String name, userGuid, password, phoneNo, email, address;
  User(
      {this.id,
      this.accountTypeId,
      this.schoolId,
      this.name,
      this.isActive,
      this.userGuid,
      this.password,
      this.phoneNo,
      this.email,
      this.address});
  Map<String, dynamic> toMap() => {
        "id": id,
        "accountTypeId": accountTypeId,
        "schoolId": schoolId,
        "name": name,
        "isActive": isActive,
        "userGuid": userGuid,
        "password": password,
        "phoneNo": phoneNo,
        "email": email,
        "address": address
      };

  //to receive the data we need to pass it from Map to json
  //para recibir los datos necesitamos pasarlo de Map a json
  factory User.fromMap(Map<String, dynamic> json) => new User(
      id: json["id"],
      accountTypeId: json["accountTypeId"],
      schoolId: json["schoolId"],
      name: json["name"],
      isActive: json["isActive"],
      userGuid: json["userGuid"],
      password: json["password"],
      phoneNo: json["phoneNo"],
      email: json["email"],
      address: json["address"]);
}
