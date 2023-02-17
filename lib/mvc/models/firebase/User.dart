import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../../../custom/get_route.dart';
import '../../views/auth/sign_in.dart';

class User {
  static GetStorage getStorage = GetStorage();

  final String? phone;
  final String? username;
  final String email;
  final String password;
  final String? role;
  final String? birthdate;
  User(
      {this.username,
      this.phone,
      required this.email,
      required this.password,
      this.role,
        this.birthdate,
      });

  // static signUp({ this.username, this.phone, required this.email,required this.password, String role, this.uid})

  static signIn(String email, String password) {
    return User(email: email, password: password);
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future create() async {
    try{
      var uuid = Uuid();
      final String id = uuid.v1();
      var data = await _firestore.collection("users").add({
        "password": password,
        "birthdate": birthdate,
        "email": email,
        "phone": phone,
        "username": username,
        "uuid": id,
        "role": "normal"
      });
      await getStorage.write("auth", id);
      return true;
    }catch(ex){
      throw Exception(ex);
    }
  }

  Future<Object> login() async {
    var user = await _firestore
        .collection("users")
        .where("email", isEqualTo: email)
        .where("password", isEqualTo: password)
        .get();
    if (user.docs.isEmpty) {
      return false;
    }

    return user.docs.last.data();
  }

  static toUser(var data) {
    return User(
        username: data["username"],
        role: data["role"],
        email: data["email"],
        password: "");
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getProfile() async {
    var result = await FirebaseFirestore.instance
        .collection("users")
        .where("uuid", isEqualTo: getStorage.read("auth"))
        .get();
    result.docs.forEach((element) {
      print(element.data());
    });
    return result;
  }

  static Future update(username, email, phone, birthdate) async {
    var uid = getStorage.read("auth");
    var user = await FirebaseFirestore.instance
        .collection("users")
        .where("uuid", isEqualTo: uid)
        .get();
    var doc = await user.docs.last.reference.update({
      "username": username,
      "email": email,
      "phone": phone,
      "birthdate": birthdate,
    });
    return true;
  }

  static Future updatePassword(password) async {
    var uid = getStorage.read("auth");
    var user = await FirebaseFirestore.instance
        .collection("users")
        .where("uuid", isEqualTo: uid)
        .get();
    var doc = await user.docs.last.reference.update({"password": password});
    return true;
  }

  static Future signOut(context) async {
    getStorage.remove("auth");
    CRoute.of(context).to(() => const SignInScreen());
  }

  static Future<bool> forgotPassword(email) async {
    try {
      var res = await http
          .post(Uri.parse("http://192.168.43.22:8080/reset-password"));
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data["status"] == "ok") {
          return true;
        } else {
          return false;
        }
      }
      return true;
    } catch (ex) {
      throw Exception(ex);
    }
  }
}
