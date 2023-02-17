import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:my_app/custom/complaint_file.dart';
import 'package:my_app/mvc/models/firebase/firebase_custom.dart';
import 'package:my_app/custom/firebase_storage_upload.dart';
import 'package:my_app/custom/get_route.dart';
import 'package:my_app/mvc/models/models/complaint_model.dart';
import 'package:my_app/mvc/views/home/home.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

import 'package:video_thumbnail/video_thumbnail.dart';

import '../../models/encryption/Complaint.dart';

class ComplaintController {
  ComplaintFilePicker file = ComplaintFilePicker();
  final GlobalKey<FormState> form = GlobalKey<FormState>();
  String detailsText = "Details";
  String attachmentsText = "Attachments";
  String details = "";
  String sendText = "Send";
  bool loading = false;
  final GetStorage _storage = GetStorage();

  Map<String, List<File>> files = {
    "picture": [],
    "audio": [],
    "video": [],
    "documents": []
  };

  List<String> thumbnails = [];

  var detailsValidate =
      ValidationBuilder().minLength(7).maxLength(255).required().build();

  getImageVideo(file) async {
    final int8list = await VideoThumbnail.thumbnailFile(
      video: file.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      quality: 25,
    );
    return int8list;
  }

  var firebaseStorage = FirebaseStorageUpload();
  var firebaseRef = FirebaseBase();
  send(context) async {
    Map<String, List<Map>> linksFiles = {
      "picture": [],
      "audio": [],
      "video": [],
      "documents": []
    };
    //
    List<String> keys = ["picture", "audio", "video", "documents"];
    //
    // firebaseStorage.clearLink();

      Complaint complaint = Complaint(files: files, text: details);
      var com = await complaint.crypto();

      for(var i = 0;i<=3;i++){
        firebaseStorage.clearLink();
        await firebaseStorage.uploadFile(com.filesEnd![keys[i]]!);
        for (var element in firebaseStorage.links) {

        linksFiles[keys[i]]!.add(element.toMap());
        }
      }

    // for (var i in  ) {
    //   if (i.isNotEmpty) {
    //     firebaseStorage.clearLink();
    //     for(var o in i) {
    //       await firebaseStorage.uploadFile(o);
    //     }
    //     linksFiles[keys[count]]!.addAll(firebaseStorage.links);
    //   }
    //   count++;
    // }
    var uuid = const Uuid();
    // var user = FirebaseAuth.instance.currentUser;
    await firebaseRef.addComplaints(
      ComplaintModel(
        uuid.v1(),
        _storage.read("auth"),
        com.text,
        linksFiles,
        DateFormat.yMd().format(DateTime.now()).toString(),
        "waiting",
        com.progressId!.toString()
      ),
    );
    toHome(context);
  }

  toHome(context) {
    details = "";
    firebaseStorage.clearLink();
    CRoute.of(context).pop();
  }
}
