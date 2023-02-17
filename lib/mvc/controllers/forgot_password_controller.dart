import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:my_app/mvc/models/firebase/User.dart';
import '../views/home/home.dart';

class ForgotPasswordController {
  final GlobalKey<FormState> form = GlobalKey<FormState>();
  var emailValidate = ValidationBuilder()
      .email()
      .required()
      .maxLength(30)
      .minLength(10)
      .build();

  String email = "";

  forgot(context) async {
    form.currentState!.validate();
    var result = await User.forgotPassword(email);
    if(result == true){
      showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Message"),
              content: const Text("Are you sure you want to exit?"),
              actions: [
                TextButton(
                  onPressed: () {
                   
                    Navigator.of(context).pop();
                  },
                  child: const Text("Yes"),
                ),
              ],
            ),
          );
    }else{
      //
    }
    // Get.offAll(const HomeScreen());
  }
}
