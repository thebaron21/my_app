import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/custom/get_route.dart';
import 'package:my_app/mvc/models/firebase/User.dart';
import 'package:my_app/mvc/models/firebase/authentication_firebase.dart';
import 'package:my_app/mvc/models/models/profile_model.dart';
import 'package:my_app/mvc/views/auth/sign_in.dart';
import 'package:my_app/mvc/views/drawer/settings_screen.dart';
import 'package:sizer/sizer.dart';
import '../color.dart';
import '../mvc/views/drawer/profile_screen.dart';

class DrawerApp {
  static AuthFirebase app = AuthFirebase();
  static Drawer drawerApp(context) {
    return Drawer(
      child: Column(
        children: [
          Container(
              width: 100.w,
              height: 30.h,
              color: MColor.blue.withRed(39),
              child: FutureBuilder(
                future: User.getProfile(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasData) {
                    ProfileModel user =
                        ProfileModel.toJson(snapshot.data!.docs.first.data());
                    return Column(
                      children: [
                        SizedBox(height: 5.h),
                        Container(
                          width: 30.w,
                          height: 20.h,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage("assets/img/avatar.png"),
                            ),
                          ),
                        ),
                        Text(
                          user.username,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: Colors.white),
                        )
                      ],
                    );
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
              )),
          ListView.builder(
              shrinkWrap: true,
              itemCount: _items(context).length,
              itemBuilder: (context, index) {
                ItemMenu item = _items(context)[index];
                return InkWell(
                  onTap: () => item.onPressed(),
                  child: ListTile(
                    title: Text(item.text),
                    leading: item.icon,
                  ),
                );
              }),
        ],
      ),
    );
  }

  static List<ItemMenu> _items(context) {
    return [
      ItemMenu(
          text: "Profile",
          icon: Icon(Icons.person, color: MColor.blue),
          onPressed: () {
            CRoute.of(context).push(() => const ProfileScreen());
          }),
      // ItemMenu(
      //   text: "Settings",
      //   icon: Icon(Icons.settings, color:MColor.blue),
      //   onPressed: (){
      //     CRoute.of(context).push(() => const SettingsScreen());
      //
      //   },
      // ),
      ItemMenu(
        text: "Log Out",
        icon: Icon(Icons.logout, color: MColor.blue),
        onPressed: () {
          User.signOut(context);
          
        },
      )
    ];
  }
}

class ItemMenu {
  String text;
  Icon icon;
  Function onPressed;

  ItemMenu({required this.text, required this.icon, required this.onPressed});
}
