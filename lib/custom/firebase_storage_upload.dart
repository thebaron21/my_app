import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';

import '../mvc/models/firebase/crypto_file.dart';

class FirebaseStorageUpload {
  String bucket = "gs://cybercrime-5c426.appspot.com";
  final List<CryptoFileUpload> links = [];

  clearLink(){
    links.clear();
  }
  Future uploadFile(List<CryptoFile> files) async {
    FirebaseStorage firebaseStorage =
        FirebaseStorage.instanceFor(bucket: bucket);
    if (files.isNotEmpty) {
      for (var item in files) {
        String nameF = path.basename(item.file.path);
        var res = await firebaseStorage.ref("complaints/$nameF").putFile(item.file);
        var link = await res.ref.getDownloadURL();
        CryptoFileUpload cf = CryptoFileUpload(link,item.type);
        links.add(cf);
      }
    }
  }
}
