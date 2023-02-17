
class ProfileModel{
  String birthdate;
  final String phone;
  final String email;
  final String username;

  ProfileModel.toJson(var json) :
    username = json["username"],
    email = json["email"],
   phone = json["phone"],
birthdate = json["birthdate"];
}