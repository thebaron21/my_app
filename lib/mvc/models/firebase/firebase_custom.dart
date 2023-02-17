import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_app/mvc/models/firebase/authentication_firebase.dart';
import 'package:my_app/mvc/models/models/complaint_model.dart';
import 'package:my_app/mvc/models/models/regulation_model.dart';

class FirebaseBase {
  var firestore = FirebaseFirestore.instance;
  var authFirebase = AuthFirebase();
  final  GetStorage _storage = GetStorage();
  Future addComplaints(ComplaintModel complaint) async {
    var complaintRef = firestore.collection("complaints");
    await complaintRef.add(complaint.toJson());
    return true;
  }

  Future<List<ComplaintModel>> getComplaints() async {
    var complaints = firestore.collection("complaints").where(
          "userId",
          isEqualTo: _storage.read("token")
        );

    List<ComplaintModel> items = [];
    var value = await complaints.get();
    for (var element in value.docs) {
      var el = ComplaintModel.toJson(element.data());
      items.add(el);
    }
    return items;
  }

  Future<List<RegulationModel>> getRegulations() async {
    var regulations = firestore.collection("regulations");
    List<RegulationModel> regs = [];
    var value = await regulations.get();

    for (var el in value.docs) {
      var elItem = RegulationModel.toJson(el.data(), el.id);
      regs.add(elItem);
    }
    return regs;
  }
}
