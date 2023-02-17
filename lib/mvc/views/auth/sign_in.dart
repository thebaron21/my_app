import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_app/color.dart';
import 'package:my_app/custom/complaint_file.dart';
import 'package:my_app/custom/get_route.dart';
import 'package:my_app/mvc/models/encryption/User.dart';
import 'package:my_app/mvc/models/utils/public_key.dart';
import 'package:sizer/sizer.dart';
import '../../controllers/sign_in_controller.dart';
import '../../models/firebase/User.dart';
import '../../models/utils/rsa_utils.dart';
import '../home/home.dart';
import 'sign_up.dart';
import 'package:path_provider/path_provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final SignInController _controller = SignInController();
  bool loading = false;
  bool isLoading = false;
  File fileImage = File("");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 6.w,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _controller.form,
            child: Column(
              children: [
                SizedBox(height: 9.h),
                Center(
                  child: Container(
                    width: 60.w,
                    height: 15.h,
                    decoration: const BoxDecoration(
                      // color: Colors.black,
                      image: DecorationImage(
                        image: AssetImage("assets/img/logo.png"),
                      ),
                    ),
                  ),
                ),
                _title(),
                SizedBox(height: 8.h),
                TextFormField(
                  onSaved: (value) => _controller.email = value!,
                  validator: _controller.emailValidate,
                  decoration: InputDecoration(
                    hintText: _controller.emailText,
                    prefixIcon: Icon(Icons.email_outlined, color: MColor.blue),
                    labelText: _controller.emailText,
                    border: const OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 4.h),
                TextFormField(
                  onSaved: (value) => _controller.password = value!,
                  obscureText: _controller.hidePassword,
                  validator: _controller.passwordValidate,
                  decoration: InputDecoration(
                    hintText: _controller.passwordText,
                    prefixIcon: Icon(Icons.lock_outline, color: MColor.blue),
                    labelText: _controller.passwordText,
                    // suffixIcon: Icon(Icons.),
                    // suffix:
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() => _controller.hidePassword =
                            !_controller.hidePassword);
                      },
                      icon: Icon(
                        _controller.hidePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: _controller.hidePassword
                            ? MColor.grey
                            : MColor.blue,
                      ),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => _controller.forgotPass(context),
                    child: Text(
                      _controller.forgotPasswordText,
                      style: TextStyle(
                        color: MColor.blue,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                InkWell(
                  onTap: () async {
                    try{
                      setState(() => loading = true);

                      bool isValidate = _controller.form.currentState!.validate();
                      if (isValidate) {
                        _controller.form.currentState!.save();
                        UserEncryption userEncryption = await UserEncryption.login(_controller.email, _controller.password);
                        print("email ${userEncryption.email}");
                        print("password : ${userEncryption.password}");
                        User user =
                        User.signIn(userEncryption.email,userEncryption.password);
                        //
                        var userData = await user.login();
                        //   // ignore: unnecessary_null_comparison
                        if (userData == false) {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Error"),
                              content: Container(
                                width: 10.w,
                                height: 5.h,
                                margin: const EdgeInsets.only(top: 15),
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                    AssetImage("assets/img/error-icon.png"),
                                  ),
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: const Text("close"),
                                ),
                              ],
                            ),
                          );
                        } else {
                          User userD = User.toUser(userData);
                          // GetStorage getStorage = GetStorage();
                          // getStorage.write("token", userD.uid);
                          // ignore: use_build_context_synchronously
                          CRoute.of(context).to(() => const HomeScreen());
                        }
                      }
                    }catch(ex){
                      setState(() => loading = false);
                    }finally{
                      setState(() => loading = false);
                    }
                    //

                  },
                  child: Container(
                    width: 95.w,
                    height: 7.h,
                    decoration: BoxDecoration(
                      color: MColor.blue,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.blueAccent,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: loading == true
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Text(
                            _controller.loginText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              // fontWeight: FontWeight.w100,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 3.h),

                // ignore: avoid_unnecessary_containers
                Container(
                  child: Row(
                    children: [
                      const Text(
                        "Don't have account?",
                        style: TextStyle(
                          color: Colors.blueGrey,
                        ),
                      ),
                      TextButton(
                        child: Text(
                          "create a new account",
                          style: TextStyle(
                            color: MColor.blue,
                          ),
                        ),
                        onPressed: () {
                          CRoute.of(context).push(() => const SignUpScreen());
                          // Get.toNamed("/signup");
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _title() {
    return Text(
      "Sign to continue",
      style: TextStyle(
        color: MColor.blue.withOpacity(0.5),
        fontFamily: "Alexandria",
      ),
    );
  }
}
