import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:my_app/mvc/models/firebase/User.dart';
import 'package:my_app/mvc/models/firebase/authentication_firebase.dart';

import '../views/home/home.dart';

extension CustomValidationBuilder on ValidationBuilder {
  confirmation(password) => add((value) {
        if (value != password) {
          return 'Passwords do NOT match';
        }
        return null;
      });
}

class SignUpController {
  final GlobalKey<FormState> form = GlobalKey<FormState>();

  bool hidePassword = true;

  String username = "";
  String email = "";
  String phone = "";
  String password = "";
  String confirmation = "";
  String birthday = "";

  String usernameText = "USER NAME";
  String emailText = "EMAIL";
  String phoneText = "PHONE NUMBER";
  String birthdayText = "BIRTHDAY";
  String passwordText = "PASSWORD";
  String confirmationText = "CONFIRMATION PASSWORD";

  var usernameValidate =
      ValidationBuilder().maxLength(30).minLength(7).required().build();
  var emailValidate =
      ValidationBuilder().email().maxLength(30).required().build();
  var phoneValidate = ValidationBuilder()
      .phone()
      .maxLength(15)
      .minLength(10)
      .required()
      .build();
  var birthdayValidate = ValidationBuilder().required().build();
  TextEditingController birthdate = TextEditingController();
  var passwordValidate =
      ValidationBuilder().required("").maxLength(30).minLength(10).build();

  confirmationPasswordValidate() => ValidationBuilder()
      .confirmation(password)
      .required("")
      .maxLength(30)
      .minLength(10)
      .build();

  String signUpText = "Sign UP";

  signUp(context) async {
    User user = User(email: email,password:password);
    AuthFirebase firebase = AuthFirebase();
    var result = await firebase.signUp(
        email: email,
        password: password,
        username: username,
        phone: phone,
        birthdate: birthdate.text);
    switch (result) {
      case RegisterState.Success:
        // Navigator.pushReplacement(context, MaterialPageRoute(
        //   builder: (context) => const HomeScreen(),
        // ));
        break;
      case RegisterState.WeakPassword:
        Get.snackbar(
          "Error",
          "Weak password",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        break;
      case RegisterState.EmailAlreadyInUse:
        Get.snackbar(
          "Error",
          "Email used",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        break;
      case RegisterState.InvalidEmail:
        Get.snackbar(
          "Error",
          "Error Email",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        break;
      case RegisterState.Unknown:
        Get.snackbar(
          "error",
          "unknown error",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        break;
      case RegisterState.Failure:
        Get.snackbar(
          "error",
          "unknown error",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        break;
    }
  }
}
