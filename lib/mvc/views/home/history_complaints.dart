import 'package:flutter/material.dart';
import 'package:my_app/color.dart';
import 'package:my_app/mvc/models/firebase/firebase_custom.dart';
import 'package:my_app/custom/get_route.dart';
import 'package:my_app/mvc/models/models/complaint_model.dart';
import 'package:my_app/mvc/models/utils/rsa_utils.dart';
import 'package:my_app/widgets/drawer_app.dart';
import '../../../custom/utils_complaints.dart';
import 'details_complaint_screen.dart';

class HistoryComplaintsScreen extends StatefulWidget {
  const HistoryComplaintsScreen({Key? key}) : super(key: key);

  @override
  State<HistoryComplaintsScreen> createState() =>
      _HistoryComplaintsScreenState();
}

class _HistoryComplaintsScreenState extends State<HistoryComplaintsScreen> {
  FirebaseBase firebaseBase = FirebaseBase();
  var utils = UtilsComplaint();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: DrawerApp.drawerApp(context),
      appBar: AppBar(
          backgroundColor: MColor.blue,
          title: const Text("Complaints"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              CRoute.of(context).pop();
            },
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  var data = await firebaseBase.getComplaints();
                  for (var item in data) {
                    // var message = await RSAUtils.decryptionText(item.details,
                    //     privateKey: privateKey.key);
                    // print("Dateils :${item.details}");
                    // print("Message: ${message}");
                  }
                })
          ]),
      body: FutureBuilder(
        future: firebaseBase.getComplaints(),
        builder: (BuildContext context,
            AsyncSnapshot<List<ComplaintModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              separatorBuilder: (context, index) =>
                  Divider(thickness: 1, color: MColor.blue, height: 4),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var item = snapshot.data![index];
                // String details;
                // if (item.details.length > 10) {
                //   details = "${item.details.substring(0, 10)} ...";
                // } else {
                //   details = item.details;
                // }
                return FutureBuilder(
                    future: utils.getPrivateKey(item.processId),
                    builder: (context,AsyncSnapshot<PrivateKey> snapshot) {
                     if(snapshot.hasData){
                       return FutureBuilder(
                         future: RSAUtils.decryptionText(item.details,
                             privateKey: snapshot.data!.key),
                         builder: (context, snapshot) {
                          if(snapshot.hasData){
                            return InkWell(
                              onTap: () {
                                item.setDetails(snapshot.data!);
                                CRoute.of(context).push(() => DetailsComplaintScreen(
                                  complaint: item,
                                ));
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text(index.toString()),
                                ),
                                title: Text(snapshot.data!),
                                subtitle: Text(item.date),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 10,
                                      backgroundColor: MColor.status[item.status],
                                    ),
                                    Text(
                                      item.status,
                                      style: TextStyle(
                                        color: MColor.status[item.status],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }else if (snapshot.hasError) {
                            return Center(
                              child: Text(snapshot.error.toString()),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(color: MColor.blue),
                            );
                          }
                         }
                       );
                     }else if (snapshot.hasError) {
                       return Center(
                         child: Text(snapshot.error.toString()),
                       );
                     } else {
                       return Center(
                         child: CircularProgressIndicator(color: MColor.blue),
                       );
                     }
                    });
              },
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
      ),
    );
  }
}
