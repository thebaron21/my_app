import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/color.dart';
import 'package:my_app/custom/get_route.dart';
import 'package:my_app/mvc/controllers/home_controller.dart';
import 'package:my_app/mvc/views/drawer/profile_screen.dart';
import 'package:my_app/widgets/drawer_app.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = HomeController();

  bool _canPop = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
         await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Message"),
              content: const Text("Are you sure you want to exit?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("No"),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _canPop = true;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text("Yes"),
                ),
              ],
            ),
          );
          return _canPop;
      },
      child: Scaffold(
        drawer: DrawerApp.drawerApp(context),
        appBar: AppBar(
          backgroundColor: MColor.blue,
          title: const Text("HOME"),
          actions: [
            InkWell(
              onTap: (){
                CRoute.of(context).push(() => const ProfileScreen());
              },
              child: Container(
                width: 10.w,
                height: 10.h,
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: MColor.grey, width: 1),
                  image: const DecorationImage(
                    image: AssetImage("assets/img/avatar.png"),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 7.h),
              Container(
                width: 70.w,
                height:16.h,
                decoration: const BoxDecoration(
                  image:DecorationImage(
                    image:AssetImage("assets/img/logo.png"),
                    // fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                "you can select options",
                // textAlign: TextAlign.end,
                style: TextStyle(
                  color:MColor.grey,
                ),
              ),
              SizedBox(height: 5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cardItem(
                    text: "New \nComplaint",
                    image: "assets/img/add_complaints.png",
                    onTap: ()=> controller.newComplaint(context),
                  ),
                  cardItem(
                    text: "History \nComplaints",
                    image: "assets/img/history_complaint.png",
                    onTap:()=> controller.historyComplaint(context),
                  ),
                ],
              ),
              cardItem(
                text: "Regulations",
                image: "assets/img/regulations.png",
                onTap:()=> controller.regulations(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cardItem(
      {required String text,
      required String image,
      required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15.0),
        margin: const EdgeInsets.all(10.0),
        width: 35.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          border:Border.all(color:MColor.grey.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 9.h,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(image),
                ),
              ),
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MColor.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
