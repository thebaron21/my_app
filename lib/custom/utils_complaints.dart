
import 'package:cloud_firestore/cloud_firestore.dart';
class PrivateKey{
  String key;
  PrivateKey(this.key);
}
class UtilsComplaint{
  var firestore = FirebaseFirestore.instance;

  Future<PrivateKey> getPrivateKey(processId)async{
    var data = await firestore.collection("keys")
    .where("progressId" , isEqualTo: num.parse(processId))
        .get();
    var d = data.docs.first.data();
    return PrivateKey(d["privateKey"]);
  }
}
