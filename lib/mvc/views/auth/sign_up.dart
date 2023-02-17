import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_app/color.dart';
import 'package:my_app/custom/get_route.dart';
import 'package:my_app/mvc/controllers/sign_up_controller.dart';
import 'package:my_app/mvc/models/encryption/User.dart';
import 'package:my_app/mvc/models/firebase/authentication_firebase.dart';
import 'package:my_app/mvc/models/utils/rsa_utils.dart';
import 'package:my_app/mvc/views/home/home.dart';
import 'package:sizer/sizer.dart';

import '../../models/firebase/User.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SignUpController controller = SignUpController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: MColor.blue,
          ),
          onPressed: () {
            CRoute.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 3.h),
                _title(),
                SizedBox(height: 5.h),
                _field(),
                SizedBox(height: 1.h),
                signUp(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget signUp() {
    return InkWell(
      onTap: loading == true
          ? null
          : () async {
              bool isValidate = controller.form.currentState!.validate();
              if (isValidate) {
              setState(() => loading = true);
                controller.form.currentState!.save();
                try{
                await signUpLogic();
                }catch(ex){
                  setState(() => loading = false);
                }finally{
                  setState(() => loading = false);
                }

              }
            },
      child: Container(
        width: loading == false ? 95.w : 7.h,
        height: 7.h,
        decoration: BoxDecoration(
          color: loading == false ? MColor.blue : MColor.grey,
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
                child: CircularProgressIndicator(
                color: Colors.white,
              ))
            : Text(
                controller.signUpText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  // fontWeight: FontWeight.w100,
                ),
              ),
      ),
    );
  }

  _title() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Create Account",
          style: TextStyle(
            color: MColor.blue,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          "create a new account",
          style: TextStyle(
            color: MColor.grey,
          ),
        ),
      ],
    );
  }

  _field() {
    return Form(
      key: controller.form,
      child: Column(
        children: [
          TextFormField(
            validator: controller.usernameValidate,
            keyboardType: TextInputType.name,
            onChanged: (value) => setState(() => controller.username = value),
            decoration: InputDecoration(
              hintText: controller.usernameText,
              prefixIcon: Icon(Icons.person_outline, color: MColor.blue),
              labelText: controller.usernameText,
              border: const OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 2.h),
          TextFormField(
            onChanged: (value) => setState(() => controller.email = value),
            validator: controller.emailValidate,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: controller.emailText,
              prefixIcon: Icon(Icons.email_outlined, color: MColor.blue),
              labelText: controller.emailText,
              border: const OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 2.h),
          TextFormField(
            validator: controller.phoneValidate,
            onChanged: (value) => setState(() => controller.phone = value),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: controller.phoneText,
              prefixIcon:
                  Icon(Icons.phone_android_outlined, color: MColor.blue),
              labelText: controller.phoneText,
              border: const OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 2.h),
          TextFormField(
            controller: controller.birthdate,
            validator: controller.birthdayValidate,
            onChanged: (value) => setState(() => controller.birthday = value),
            keyboardType: TextInputType.datetime,
            smartDashesType: SmartDashesType.disabled,
            decoration: InputDecoration(
              hintText: controller.birthdayText,
              prefixIcon: Icon(Icons.date_range, color: MColor.blue),
              labelText: controller.birthdayText,
              border: const OutlineInputBorder(),
            ),
            readOnly: true,
            //set it true, so that user will not able to edit text
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1950),
                //DateTime.now() - not to allow to choose before today.
                lastDate: DateTime(2100),
              );

              if (pickedDate != null) {
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);

                setState(() => controller.birthdate.text = formattedDate);
              } else {}
            },
          ),
          SizedBox(height: 2.h),
          TextFormField(
            validator: controller.passwordValidate,
            onChanged: (value) => setState(() => controller.password = value),
            obscureText: controller.hidePassword,
            decoration: InputDecoration(
              hintText: controller.passwordText,
              prefixIcon: Icon(Icons.lock_outline, color: MColor.blue),
              labelText: controller.passwordText,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(
                      () => controller.hidePassword = !controller.hidePassword);
                },
                icon: Icon(
                  controller.hidePassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: controller.hidePassword ? MColor.grey : MColor.blue,
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          TextFormField(
            validator: controller.confirmationPasswordValidate(),
            onChanged: (value) =>
                setState(() => controller.confirmation = value),
            obscureText: controller.hidePassword,
            decoration: InputDecoration(
              hintText: controller.confirmationText,
              prefixIcon: Icon(Icons.lock_outline, color: MColor.blue),
              labelText: controller.confirmationText,
              border: const OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Future signUpLogic() async {
    var user = User(
        email: controller.email,
        password: RSAUtils.generateMd5(controller.password),
        username: controller.username,
        phone: controller.phone,
        birthdate: controller.birthdate.text);
    try{
    var result = await user.create();
    if(result == true){
    // ignore: use_build_context_synchronously
    CRoute.of(context).pushRemove(() => const HomeScreen());
    }

    }catch(ex){
      const snackBar = SnackBar(
        content: Text("unknown error"),
        backgroundColor: Colors.redAccent,
      );
      showSack(snackBar);
    }

  }

  showSack(s) {
    ScaffoldMessenger.of(context).showSnackBar(s);
  }

  void toHome() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ));
  }
}
