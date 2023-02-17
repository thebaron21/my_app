
// RSAKeypair rsaKeypair = RSAKeypair.fromRandom();
//   String message = DateTime.now().millisecondsSinceEpoch.toRadixString(16);

//   String signature = rsaKeypair.privateKey.createSHA256Signature(utf8.encode(message) as Uint8List);
//   bool verified = rsaKeypair.publicKey.verifySHA256Signature(message, signature);
import 'dart:io';
import 'dart:typed_data';

import 'package:fast_rsa/fast_rsa.dart';
import 'package:get_storage/get_storage.dart';
class CRsa{
  var rsa = RSA.generate(1024);
  final storage = GetStorage();
   init() async{
    var rsaAsync = await rsa;
    if(!storage.hasData("publicKey") && !storage.hasData("privateKey")) {
      storage.write("publicKey", rsaAsync.publicKey);
      storage.write("privateKey", rsaAsync.privateKey);
    }
  }

  publicKey(){
     return storage.read("publicKey");
  }

  privateKey(){
    return storage.read("privateKey");
  }
  
  encryptionText(String s,String publicKey)async{
    var rsa = await RSA.generate(1024);
    var cyberText = await RSA.encryptOAEP(s, "complaints", Hash.MD5, publicKey);
    return cyberText;
  }


  decryptionText(String s,String privateKey)async{
    var rsa = await RSA.generate(1024);
    var text = await RSA.encryptOAEP(s, "complaints", Hash.MD5, privateKey);
    return text;
  }

  // encryptionFile(File file)async{
  //   Uint8List message = await file.readAsBytes();
  //   var cyberFile = await RSA.encryptOAEPBytes(message, "complaints", Hash.MD5, await _publicKey());
  //   var filec = File.fromRawPath(cyberFile);
  //   print(filec);
  //   // filec.rename(file)
  // }
}