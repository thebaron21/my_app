import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_app/color.dart';
import 'package:my_app/custom/get_route.dart';
import 'package:my_app/custom/rsa_algorithom.dart';
import 'package:my_app/mvc/controllers/home/complaint_controller.dart';
import 'package:my_app/widgets/drawer_app.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

class NewComplaintScreen extends StatefulWidget {
  const NewComplaintScreen({Key? key}) : super(key: key);

  @override
  State<NewComplaintScreen> createState() => _NewComplaintScreenState();
}

class _NewComplaintScreenState extends State<NewComplaintScreen> {
  ComplaintController controller = ComplaintController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: DrawerApp.drawerApp(context),
      appBar: AppBar(
        backgroundColor: MColor.blue,
        title: const Text("new Complaint"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            CRoute.of(context).pop();
            // CRsa rsa = CRsa();
            // await rsa.init();
            // var result = await rsa.encryptionText("ahmed", rsa.publicKey() );
            // print(result);
            // var result2 = await rsa.decryptionText(result, rsa.privateKey() );
            // print(result2);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 3.h),
              _title(),
              SizedBox(height: 4.h),
              _field(),
              SizedBox(height: 4.h),
              btnIcons(),
              SizedBox(height: 4.h),
              controller.files["picture"]!.length == 0
                  ? Container()
                  : _line("Picture"),
              controller.files["picture"]!.length == 0
                  ? Container()
                  : _files("picture"),
              controller.files["documents"]!.length == 0
                  ? Container()
                  : _line("doc"),
              controller.files["documents"]!.length == 0
                  ? Container()
                  : _files("documents"),
              controller.files["video"]!.length == 0
                  ? Container()
                  : _line("video"),
              controller.files["video"]!.length == 0
                  ? Container()
                  : _files("video"),
              controller.files["audio"]!.length == 0
                  ? Container()
                  : _line("audio"),
              controller.files["audio"]!.length == 0
                  ? Container()
                  : _files("audio"),
              SizedBox(height: 4.h),
              sendComplaint(),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  _title() {
    return Text(
      "Add New Complaint",
      style: TextStyle(
        fontSize: 27.sp,
        color: MColor.blue,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  _field() {
    return Form(
      key: controller.form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(controller.detailsText, style: styleText),
          SizedBox(height: 1.h),
          TextFormField(
            onChanged: (value) => controller.details = value!,
            minLines: 10,
            maxLines: 40,
            maxLength: 255,
            keyboardType: TextInputType.name,
            validator: controller.detailsValidate,
            decoration: InputDecoration(
              hintText: controller.detailsText,
              border: const OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 2.h),
          Text(controller.attachmentsText, style: styleText),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }

  TextStyle styleText =
      const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF555555));

  var divier = Container(
    height: 5.h, // 100.w
    width: 0.2.w,
    color: MColor.grey,
  );

  btnIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () async {
            var result = await controller.file.getPicture();
            if (result != null) {
              setState(() => controller.files["picture"] = result);
            }
          },
          child: Image.asset(
            "assets/icons/icons8-compact-camera-120(-xxxhdpi).png",
            width: 10.w,
          ),
        ),
        divier,
        TextButton(
          onPressed: () async {
            var result = await controller.file.getDocument();
            if (result != null) {
              setState(() => controller.files["documents"] = result);
            }
          },
          child: Image.asset(
            "assets/icons/icons8-document-64.png",
            width: 10.w,
          ),
        ),
        divier,
        TextButton(
          onPressed: () async {
            var result = await controller.file.getVideo();
            if (result != null) {
              for (var element in result!) {
                var image = await controller.getImageVideo(element);
                setState(() => controller.thumbnails.add(image));
              }
              setState(() => controller.files["video"] = result);
            }
          },
          child: Image.asset(
            "assets/icons/icons8-documentary-100.png",
            width: 10.w,
          ),
        ),
        divier,
        TextButton(
          onPressed: () async {
            var result = await controller.file.getSound();
            if (result != null) {
              setState(() => controller.files["audio"] = result);
            }
          },
          child: Image.asset(
            "assets/icons/icons8-microphone-100.png",
            width: 10.w,
          ),
        ),
      ],
    );
  }

  Widget sendComplaint() {
    return InkWell(
      onTap: controller.loading == true
          ? null
          : () async {
              final valid = controller.form.currentState;

              if (valid!.validate()) {
                try {

                setState(() => controller.loading = true);
                controller.form.currentState!.save();
                await controller.send(context);

                } catch (e) {
                  throw Exception(e);
                }finally{
                setState(() => controller.loading = false);
                }
              }
            },
      child: Center(
        child: Container(
          width: controller.loading == false ? 95.w : 7.h,
          height: 7.h,
          decoration: BoxDecoration(
            color: controller.loading == false ? MColor.blue : MColor.grey,
            borderRadius: BorderRadius.circular(5),
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
                  controller.sendText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    // fontWeight: FontWeight.w100,
                  ),
                ),
        ),
      ),
    );
  }

  _files(String s) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
      ),
      physics: const ClampingScrollPhysics(),
      itemCount: controller.files[s]?.length ?? 0,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        File file = controller.files[s]![index];
        return Stack(
          children: [
            _profileFile(s, file, index),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  setState(() {
                    controller.files[s]!.removeAt(index);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
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

  _profileFile(String s, File file, index) {
    File filex = File("");
    bool isVactory = true;
    String assetName = "assets/img/other.png";
    if (s == "picture") {
      filex = file;
    } else if (s == "video") {
      filex = File(controller.thumbnails[index]);
    } else if (s == "documents") {
      isVactory = false;
      assetName = "assets/img/pdf.png";
    } else if (s == "audio") {
      isVactory = false;
      assetName = "assets/img/mp3.png";
    }

    return Container(
      margin: const EdgeInsets.all(5),
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        image: isVactory
            ? DecorationImage(image: FileImage(filex), fit: BoxFit.cover)
            : DecorationImage(image: AssetImage(assetName), fit: BoxFit.cover),
      ),
    );
  }
}
