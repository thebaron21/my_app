

class PublicKey{
  int progressId;
  String publicKey;


  PublicKey.toJson(var json):
      progressId = json["progressId"],
      publicKey = json["publicKey"];

  static toError(){
    return "error";
  }

}