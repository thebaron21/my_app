import 'package:flutter/material.dart';
import 'package:my_app/color.dart';
import 'package:my_app/custom/get_route.dart';
import 'package:my_app/mvc/controllers/forgot_password_controller.dart';
import 'package:sizer/sizer.dart';

import '../../models/firebase/User.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  ForgotPasswordController controller = ForgotPasswordController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: MColor.blue,
          ),
          onPressed: () {
            CRoute.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 6.w,
          ),
          child: Form(
            key: controller.form,
            child: Column(
              children: [
                SizedBox(height: 6.h),
                _title(),
                SizedBox(height: 6.h),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: MColor.grey.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextFormField(
                    validator: controller.emailValidate,
                    onSaved: (value) => controller.email = value!,
                    decoration: InputDecoration(
                      hintText: "ENTER YOUR EMAIL",
                      labelText: "EMAIL",
                      prefixIcon: const Icon(Icons.email_outlined),
                      hintStyle: TextStyle(
                          fontFamily: "Alexandria", color: MColor.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                _btnReset()
              ],
            ),
          ),
        ),
      ),
    );
  }

  _title() {
    return Column(
      children: [
        Text(
          "Forgot Password ",
          style: TextStyle(
            fontSize: 30,
            fontFamily: "Alexandria",
            color: MColor.blue,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          "Please Enter your email for\n send reset new Password",
          style: TextStyle(
            color: MColor.grey,
            fontWeight: FontWeight.w300,
          ),
        )
      ],
    );
  }

  _btnReset() {
    return InkWell(
      onTap: () async{
        var result = await User.forgotPassword(controller.email);
    // if(result == true){
    //   showDialog(
    //         context: context,
    //         builder: (context) => AlertDialog(
    //           title: const Text("Message"),
    //           content: const Text("Are you sure you want to exit?"),
    //           actions: [
    //             TextButton(
    //               onPressed: () {
                   
    //                 Navigator.of(context).pop();
    //               },
    //               child: const Text("Yes"),
    //             ),
    //           ],
    //         ),
    //       );
    // }else{
    //   //
    // }
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
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 4,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Text(
          "SEND",
          style: TextStyle(
            fontFamily: "Alexandria",
            color: Colors.white,
            fontSize: 18,
            // fontWeight: FontWeight.w100,
          ),
        ),
      ),
    );
  }
}
