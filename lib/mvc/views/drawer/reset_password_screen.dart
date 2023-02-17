import 'package:flutter/material.dart';
import 'package:my_app/color.dart';
import 'package:my_app/custom/get_route.dart';
import 'package:my_app/mvc/controllers/edit_password_controller.dart';
import 'package:my_app/mvc/models/firebase/User.dart';
import 'package:my_app/mvc/models/utils/rsa_utils.dart';
import 'package:sizer/sizer.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  EditPasswordController controller = EditPasswordController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MColor.blue,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Form(
          key: controller.form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              Text(
                "Modify The Password",
                style: TextStyle(
                  color: MColor.blue,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.h),
              TextFormField(
                validator: controller.passwordValidate,
                onChanged: (value) =>
                    setState(() => controller.password = value),
                obscureText: controller.hidePassword,
                decoration: InputDecoration(
                  hintText: controller.passwordText,
                  prefixIcon: Icon(Icons.lock_outline, color: MColor.blue),
                  labelText: controller.passwordText,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(
                        () =>
                            controller.hidePassword = !controller.hidePassword,
                      );
                    },
                    icon: Icon(
                      controller.hidePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color:
                          controller.hidePassword ? MColor.grey : MColor.blue,
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
              updatePassword(),
            ],
          ),
        ),
      ),
    );
  }

  Widget updatePassword() {
    return InkWell(
      onTap: controller.loading == true
          ? null
          : () async {
              bool isValidate = controller.form.currentState!.validate();
              if (isValidate) {
                setState(() => controller.loading = true);
                controller.form.currentState!.save();
                var result =
                    await User.updatePassword(RSAUtils.generateMd5(controller.password));
                    //controller.app.updatePassword(controller.password);
                if (result == true) {
                  const snackBar = SnackBar(
                    content: Text("Success"),
                    backgroundColor: Colors.green,
                  );
                  showMessage(snackBar);
                  back();
                } else {
                  var snackBar = SnackBar(
                    content: const Text("error"),
                    backgroundColor: MColor.red,
                  );
                  showMessage(snackBar);
                }
                setState(() => controller.loading = false);
              }
            },
      child: Container(
        width: controller.loading == false ? 95.w : 7.h,
        height: 7.h,
        decoration: BoxDecoration(
          color: controller.loading == false ? MColor.blue : MColor.grey,
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
        child: controller.loading == true
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.white,
              ))
            : Text(
                controller.updateText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  // fontWeight: FontWeight.w100,
                ),
              ),
      ),
    );
  }

  void showMessage(SnackBar snackBar) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void back() {
    CRoute.of(context).pop();
  }
}
