
import 'package:my_app/mvc/models/utils/encrypto_item.dart';
import 'package:my_app/mvc/models/utils/public_key.dart';
import 'package:my_app/mvc/models/utils/rsa_utils.dart';

class UserEncryption{
  RSAUtils utils = RSAUtils();


  final String? uid;
  final String? phone;
  final String? username;
  final String email;
  final String password;
  final String? birthdate;
  final String role;


  UserEncryption({this.username,
    this.phone,
    required this.email,
    required this.password,
    this.role = "user",
    this.birthdate,
    this.uid});

  static Future<UserEncryption> login(email,password)async{
    PublicKey keys= await RSAUtils.getPublicKey();
    String emailC = await RSAUtils.encryptionText(email,publicKey: keys.publicKey);
    String passwordC = await RSAUtils.encryptionText(password,publicKey: keys.publicKey);
    return UserEncryption(email: emailC, password: passwordC);
  }


  static Future<UserEncryption> signUp(username,email,password,phone,birthdate)async{
    PublicKey keys= await RSAUtils.getPublicKey();
    String usernameC = await RSAUtils.encryptionText(username,publicKey: keys.publicKey);
    String emailC = await RSAUtils.encryptionText(email,publicKey: keys.publicKey);
    String passwordC = await RSAUtils.encryptionText(password,publicKey: keys.publicKey);
    String phoneC = await RSAUtils.encryptionText(phone,publicKey: keys.publicKey);
    String birthdateC = await RSAUtils.encryptionText(birthdate,publicKey: keys.publicKey);
    return UserEncryption(email: emailC, password: passwordC,username: usernameC,phone: phoneC,birthdate: birthdateC);
  }





}