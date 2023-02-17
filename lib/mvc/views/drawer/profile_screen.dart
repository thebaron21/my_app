import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/color.dart';
import 'package:my_app/custom/get_route.dart';
import 'package:my_app/mvc/models/firebase/User.dart';
import 'package:my_app/mvc/models/firebase/authentication_firebase.dart';
import 'package:my_app/mvc/models/models/profile_model.dart';
import 'package:my_app/mvc/views/drawer/edit_profile_screen.dart';
import 'package:my_app/mvc/views/home/home.dart';
import 'package:sizer/sizer.dart';

import 'reset_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthFirebase app = AuthFirebase();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed:(){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
          }
        ),
        backgroundColor: MColor.blue,
        title: const Text("Profile"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 100.w,
              height: 20.h,
              color: MColor.blue,
              child: Column(
                children: [
                  SizedBox(height: 3.h),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: MColor.red, width: 3),
                    ),
                    child: Container(
                      width: 20.w,
                      height: 10.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage("assets/img/avatar.png"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future: User.getProfile(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  ProfileModel user =
                      ProfileModel.toJson(snapshot.data!.docs.first.data());
                  String docs = snapshot.data!.docs.first.id;
                  return Column(children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _container("Username", user.username),
                        ),
                        Flexible(
                          child: _container("phone", user.phone),
                        ),
                      ],
                    ),
                    _container("email", user.email),
                    _container("BirthDay", user.birthdate),
                    _btn(
                      s: "Edit",
                      isEdit: true,
                      onTap: () {
                        CRoute.of(context).push(() =>
                            EditProfileScreen(profile: user,docs:docs));
                      },
                    ),
                    _btn(
                      s: "Reset Password",
                      isEdit: false,
                      onTap: () {
                        CRoute.of(context).push(() => const ResetPasswordScreen());
                      },
                    ),
                  ],);
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(color: MColor.blue),
                  );
                }
              },
            ),

          ],
        ),
      ),
    );
  }

  _container(String title, String s) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: MColor.grey.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF333333),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 0.1.h,
            color: MColor.grey.withOpacity(0.2),
          ),
          const SizedBox(height: 10),
          Text(
            s,
            style: const TextStyle(
              color: Color(0xFF333333),
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  _btn({required String s, required bool isEdit, required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // width: 20.w,
        height: 5.h,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: isEdit ? MColor.blue : Colors.green,
          border: Border.all(
            color: isEdit ? Colors.lightGreen : Colors.greenAccent,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          s,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }


}
