import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/color.dart';
import 'package:my_app/custom/get_route.dart';
import 'package:my_app/mvc/controllers/edit_profile_controller.dart';
import 'package:my_app/mvc/models/firebase/User.dart';
import 'package:my_app/mvc/models/models/profile_model.dart';
import 'package:my_app/mvc/views/drawer/profile_screen.dart';
import 'package:sizer/sizer.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileModel profile;
  final String docs;
  const EditProfileScreen({Key? key, required this.profile,required this.docs}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  EditProfileController controller = EditProfileController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MColor.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            children: [
              SizedBox(height: 4.h,),
              _field(),
              SizedBox(height: 4.h,),
              updateProfile()
            ],
          ),
        ),
      ),
    );
  }

  _field() {
    return Form(
      key: controller.form,
      child: Column(
        children: [
          TextFormField(
            initialValue: widget.profile.username,
            validator: controller.usernameValidate,
            keyboardType: TextInputType.name,
            // controller: controller.username,
            onSaved: (value) => controller.username.text = value!,
            decoration: InputDecoration(
              hintText: widget.profile.username,
              prefixIcon: Icon(Icons.person_outline, color: MColor.blue),
              labelText: controller.usernameText,
              border: const OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 2.h),
          TextFormField(
            initialValue: widget.profile.email,
            // controller: ,
            validator: controller.emailValidate,
            onSaved: (value) => controller.email.text=value!,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: widget.profile.email,
              prefixIcon: Icon(Icons.email_outlined, color: MColor.blue),
              labelText: controller.emailText,
              border: const OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 2.h),
          TextFormField(
            initialValue: widget.profile.phone,
            validator: controller.phoneValidate,
            onSaved: (value) => controller.phone.text = value!,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText:controller.phoneText,
              prefixIcon:
                  Icon(Icons.phone_android_outlined, color: MColor.blue),
              labelText: controller.phoneText,
              border: const OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 2.h),
          TextFormField(
            initialValue: widget.profile.birthdate,
            onSaved:(value)=> controller.birthdate.text = value!,
            validator: controller.birthdayValidate,
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
                // widget.profile.birthdate = formattedDate;
                widget.profile.birthdate = formattedDate;
              } else {}
            },
          ),
          SizedBox(height: 2.h),


        ],
      ),
    );
  }

  Widget updateProfile() {
    return InkWell(
      onTap: controller.loading == true
          ? null
          : () async {
        bool isValidate = controller.form.currentState!.validate();
        if (isValidate) {
          setState(() => controller.loading = true);
          controller.form.currentState!.save();
          var result = await User.update(
              controller.username.text, controller.email.text,
              controller.phone.text, controller.birthdate.text);
          if (result == true) {
            const snackBar = SnackBar(
              content: Text("Success"),
              backgroundColor: Colors.green,
            );
            showMessage(snackBar);
            back();
          }
          else {
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
    
    CRoute.of(context).pushRemove(() => const ProfileScreen());
  }
}
