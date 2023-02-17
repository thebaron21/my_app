import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_app/mvc/models/firebase/authentication_firebase.dart';
import 'package:my_app/mvc/views/auth/sign_up.dart';
import 'package:my_app/mvc/views/home/home.dart';
import 'package:sizer/sizer.dart';
import 'color.dart';
import 'mvc/views/auth/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fast_rsa/fast_rsa.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  AuthFirebase app = AuthFirebase();
  GetStorage getStorage = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'الجرائم الإلكترونية',
          theme: ThemeData(primaryColor: MColor.blue, fontFamily: "Alexandria"),
          debugShowCheckedModeBanner: false,
          home:
          getStorage.hasData("auth") == false
              ? const SignInScreen()
              : const HomeScreen(),
        );
      },
    );
  }
}