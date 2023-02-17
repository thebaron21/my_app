
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:my_app/mvc/models/firebase/authentication_firebase.dart';

class EditProfileController{
  final GlobalKey<FormState> form = GlobalKey<FormState>();
  AuthFirebase app = AuthFirebase();

  bool loading = false;

  var username = TextEditingController();
  var email = TextEditingController();
  var phone = TextEditingController();
  var birthday = TextEditingController();

  String usernameText = "USER NAME";
  String emailText = "EMAIL";
  String phoneText = "PHONE NUMBER";
  String birthdayText = "BIRTHDAY";
  String passwordText = "PASSWORD";

  var usernameValidate = ValidationBuilder().maxLength(30).minLength(7).required().build();
  var emailValidate = ValidationBuilder().email().maxLength(30).required().build();
  var phoneValidate = ValidationBuilder()
      .phone()
      .maxLength(15)
      .minLength(10)
      .required()
      .build();
  var birthdayValidate = ValidationBuilder().required().build();
  TextEditingController birthdate = TextEditingController();


  String updateText = "Update";
}