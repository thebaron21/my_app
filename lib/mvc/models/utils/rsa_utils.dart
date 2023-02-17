import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:my_app/mvc/models/firebase/crypto_file.dart';
import 'package:my_app/mvc/models/utils/encrypto_item.dart';
import 'package:my_app/mvc/models/utils/public_key.dart';
import 'package:fast_rsa/fast_rsa.dart';
import 'package:path_provider/path_provider.dart';
import "package:path/path.dart" show basename;
import 'package:crypto/crypto.dart';
class RSAUtils {
  static String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }
  static Future<PublicKey> getPublicKey() async {
    try {
      var res = await http.get(Uri.parse("https://appweb-7wmt.onrender.com/new-request"));
      if (res.statusCode == 200) {
        var body = json.decode(res.body);
        if (body["status"] == 200) {
          return PublicKey.toJson(body);
        } else {
          return PublicKey.toError();
        }
      } else {
        throw Exception("error");
      }
    } catch (ex) {
      throw Exception(ex.toString());
    }
  }

  static Future<Map<String, List<CryptoFile>>> encryptionFile(Map<String, List<File>> files, {publicKey}) async {

    try {
      List<CryptoFile> filesC = [];
      List<String> keys = ["picture", "audio", "video", "documents"];
      Map<String, List<CryptoFile>> linksFiles = {
        "picture": [],
        "audio": [],
        "video": [],
        "documents": []
      };
      int count = 0;

      for (var i in files.values) {
        if (i.isNotEmpty) {
          for (var file in i) {
            // !.addAll(firebaseStorage.links);
            var result = await RSA.encryptPKCS1v15Bytes(
                file.readAsBytesSync(), await RSA.convertPublicKeyToPKCS1(publicKey));
            final directory = await getApplicationDocumentsDirectory();
            File fileE = await File("${directory.path}/${basename(file.path)}.rsa").create(recursive: true);
            fileE.writeAsBytesSync(result.toList());
            CryptoFile item = CryptoFile(fileE,basename(file.path));
            linksFiles[keys[count]]!.add(item);

          }
        }
        count++;
      }



      return linksFiles;
    } catch (ex) {
      throw Exception(ex.toString());
    }
  }

  static Future<String> encryptionText(String message,{publicKey,progressId}) async {
    try {
      var result = await RSA.encryptPKCS1v15(message,await RSA.convertPublicKeyToPKCS1(publicKey));
      return result;
      // return EncryptionItem.toObject(progressId, result);
    } catch (ex) {
      throw Exception(ex.toString());
    }
  }
  static Future<String> decryptionText(String message,{privateKey}) async {
    try {
      var result = await RSA.decryptPKCS1v15(message,await RSA.convertPrivateKeyToPKCS1(privateKey));
      return result;
      // return EncryptionItem.toObject(progressId, result);
    } catch (ex) {
      throw Exception(ex.toString());
    }
  }
}
// getName(File file){
//   List list = file.path.split("/");
//   String name = "";
//   int count = 0;
//   for(var i in list.last.toString().split(".")){
//     if(count<=1){
//       name+=i;
//     }
//     if(count==0){name+=".";}
//     count++;
//     if(count==2){
//       break;
//     }
//   }
//   return name;
// }

// Future<File> dFile(File file,privateKey)async{
//   var p = await RSA.convertPrivateKeyToPKCS1(privateKey);
//   var result = await RSA.decryptPKCS1v15Bytes(file.readAsBytesSync(), p);
//   final dire = await getApplicationDocumentsDirectory();
//   File fileC = await File("${dire.path}/rsa-file-${name(file)}").create(recursive: true);
//   fileC.writeAsBytesSync(result.toList());
//   return fileC;
// }
