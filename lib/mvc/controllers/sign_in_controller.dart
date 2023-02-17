import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:my_app/custom/get_route.dart';
import 'package:my_app/mvc/models/firebase/authentication_firebase.dart';

import '../models/firebase/User.dart';
import '../views/auth/forgot_password.dart';
import '../views/home/home.dart';
class SignInController {
  final GlobalKey<FormState> form = GlobalKey<FormState>();



  String email = "";
  String password = "";

  var emailValidate =
      ValidationBuilder().email().maxLength(30).required("dsf").build();
  var passwordValidate = ValidationBuilder().required("").maxLength(30).minLength(8).build();

  bool hidePassword = true;

  var emailText = "EMAIL";

  var passwordText = "PASSWORD";

  String forgotPasswordText = "Forgot Password?";

  String loginText = "LOG IN";


  Future loginBtn(context)async{
    User user = User.signIn(
      email,
      password
    );

    await user.login();
    // AuthFirebase firebase = AuthFirebase();
    // var result = await firebase.signIn(email: email, password: password);
    // switch (result) {
    //   case LoginState.Success:
    //     CRoute.of(context).to(() => const HomeScreen());
    //     break;
    //   case LoginState.UserNotFound:
    //     Get.snackbar(
    //       "Error",
    //       "User does not exist",
    //       backgroundColor: Colors.redAccent,
    //       colorText: Colors.white,
    //     );
    //     break;
    //   case LoginState.InvalidEmail:
    //     Get.snackbar(
    //       "Error", "The email does not exist",
    //       backgroundColor: Colors.redAccent,
    //       colorText: Colors.white,
    //     );
    //     break;
    //   case LoginState.Failure:
    //     Get.snackbar(
    //       "error", "unknown error",
    //       backgroundColor: Colors.redAccent,
    //       colorText: Colors.white,
    //     );
    //     break;
    //   case LoginState.WrongPassword:
    //     Get.snackbar(
    //       "Error", "Incorrect password",
    //       backgroundColor: Colors.redAccent,
    //       colorText: Colors.white,
    //     );
    //     break;
    // }
  }

  void _validate() {
    // bool isValidate = form.currentState!.validate();
    // if( isValidate ){
    //   form.currentState!.save();
    // }

  }

  void forgotPass(context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => const ForgotPasswordScreen(),

    ));
  }
}
