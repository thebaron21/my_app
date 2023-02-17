import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/color.dart';
import 'package:my_app/custom/get_route.dart';
import 'package:my_app/mvc/models/firebase/firebase_custom.dart';
import 'package:my_app/mvc/models/models/regulation_model.dart';
import 'package:my_app/widgets/drawer_app.dart';
import 'package:sizer/sizer.dart';

class RegulationsScreen extends StatefulWidget {
  const RegulationsScreen({Key? key}) : super(key: key);

  @override
  State<RegulationsScreen> createState() => _RegulationsScreenState();
}

class _RegulationsScreenState extends State<RegulationsScreen> {
  var firebaseBase = FirebaseBase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: DrawerApp.drawerApp(context),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              CRoute.of(context).pop();
            },
          ),
          backgroundColor: MColor.blue,
          title: const Text("Regulations"),
          // RegulationRep
        ),
        body: FutureBuilder(
          future: firebaseBase.getRegulations(),
          builder: (BuildContext context,
              AsyncSnapshot<List<RegulationModel>> snapshot) {
            if (snapshot.hasData) {
              return _listRegulations(snapshot.data);
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
        ));
  }

  Widget _listRegulations(List<RegulationModel>? data) {
    return ListView.builder(
      itemCount: data!.length,
      itemBuilder: (context, index) {
        var regulation = data![index];
        return _container(regulation.title,regulation.content);
      },
    );
  }

  _container(String title, String content) {
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
            content ?? "",
            style:const TextStyle(
              color:  Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }
}
