import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:my_app/mvc/models/firebase/authentication_firebase.dart';
extension CustomValidationBuilder on ValidationBuilder {
  confirmation(password) => add((value) {
    if (value != password) {
      return 'Passwords do NOT match';
    }
    return null;
  });
}
class EditPasswordController{

  AuthFirebase app = AuthFirebase();
  final GlobalKey<FormState> form = GlobalKey<FormState>();

  bool hidePassword = true;
  bool loading = false;
  String passwordText = "NEW PASSWORD";
  String confirmationText = "CONFIRMATION PASSWORD";

  String password = "";
  String confirmation = "";

  var passwordValidate =
  ValidationBuilder().required("").maxLength(30).minLength(10).build();

  confirmationPasswordValidate() => ValidationBuilder()
      .confirmation(password)
      .required("")
      .maxLength(30)
      .minLength(10)
      .build();

  String updateText = "Update";
}