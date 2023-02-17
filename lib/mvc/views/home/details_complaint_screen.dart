import 'package:flutter/material.dart';
import 'package:my_app/color.dart';
import 'package:my_app/custom/get_route.dart';
import 'package:my_app/mvc/models/models/complaint_model.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';
import '../../../widgets/drawer_app.dart';
import 'package:intl/intl.dart';

class DetailsComplaintScreen extends StatefulWidget {
  final ComplaintModel complaint;
  const DetailsComplaintScreen({Key? key, required this.complaint})
      : super(key: key);

  @override
  State<DetailsComplaintScreen> createState() => _DetailsComplaintScreenState();
}

class _DetailsComplaintScreenState extends State<DetailsComplaintScreen> {
  var uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: DrawerApp.drawerApp(context),
      appBar: AppBar(
        backgroundColor: MColor.blue,
        title: const Text("Details Complaint"),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              CRoute.of(context).pop();
            }),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.w),
          child: Column(
            children: [
              _container("ID", s: widget.complaint.uuid),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: _container("date", s: widget.complaint.date)),
                  _container(
                    "Status",
                    s: widget.complaint.status,
                    color: MColor.status[widget.complaint.status],
                  ),
                ],
              ),
              _container(
                "Details",
                s: widget.complaint.details,
              ),
              _container(
                "Files",
                child: _files(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _line(String s) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          s,
          style: TextStyle(color: MColor.grey),
        ),
        Container(
          width: 70.w,
          height: 0.3.h,
          color: MColor.grey,
        ),
      ],
    );
  }

  _container(String title, {String? s, Color? color, Widget? child}) {
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
          child ??
              Text(
                s ?? "",
                style: TextStyle(
                  color: color ?? const Color(0xFF333333),
                ),
              ),
        ],
      ),
    );
  }

  _files() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
      ),
      physics: const ClampingScrollPhysics(),
      itemCount: listFile().length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        String item = listFile()[index]["file"];
        return _profileFile(item);
      },
    );
  }

  _profileFile(String file) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.all(5),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          image: DecorationImage(image: NetworkImage(file), fit: BoxFit.cover),
        ),
      ),
    );
  }

  List listFile() {
    List files = [];
    widget.complaint.files.forEach((key, value) {
      if (value.length != 0) files.addAll(value);
    });
    return files;
  }
}
