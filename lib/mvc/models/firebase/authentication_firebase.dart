import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum LoginState { Success, UserNotFound, InvalidEmail, Failure, WrongPassword }

enum LogOutState { Exit }

enum RegisterState {
  Success,
  WeakPassword,
  EmailAlreadyInUse,
  InvalidEmail,
  Unknown,
  Failure
}

enum ForgotState { Failure, UserNotFound, InvalidEmail, Success }

class AuthFirebase {
  // create new instance for firebase authentication
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  // FirebaseFirestore.instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<LoginState> signIn(
      {required String email, required String password}) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return LoginState.Success;
    } on FirebaseException catch (e) {
      if (e.code == "user-not-found") {
        return LoginState.UserNotFound;
      } else if (e.code == "invalid-email") {
        return LoginState.InvalidEmail;
      } else if (e.code == "wrong-password") {
        return LoginState.WrongPassword;
      } else {
        return LoginState.Failure;
      }
    }
  }


  // Sign Up or Register New User or Create New Account
  Future<RegisterState> signUp({
    required String email,
    required String password,
    required String username,
    required String phone,
    required String birthdate,
  }) async {
    try {
      var result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _createUser(email, username, phone, birthdate, result.user!.uid);
      return RegisterState.Success;
    } on FirebaseException catch (e) {
      if (e.code == "weak-password") {
        return RegisterState.WeakPassword;
      } else if (e.code == "email-already-in-use") {
        return RegisterState.EmailAlreadyInUse;
      } else if (e.code == "invalid-email") {
        return RegisterState.InvalidEmail;
      } else if (e.code == "unknown") {
        return RegisterState.Unknown;
      } else {
        return RegisterState.Failure;
      }
    }
  }

  // Closed Account And SingOut And out unside account
  Future<LogOutState> signOut() async {
    await auth.signOut();
    return LogOutState.Exit;
  }

  // // Forgot Password but you can of user create new password by this method
  Future<ForgotState> forgotPassword({required String email}) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return ForgotState.Success;
    } on FirebaseException catch (e) {
      if (e.code == "invalid-email") {
        return ForgotState.InvalidEmail;
      } else if (e.code == "user-not-found") {
        return ForgotState.UserNotFound;
      } else {
        return ForgotState.Failure;
      }
    }
  }

  _createUser(String email, String username, String phone, String birthdate,
      uuid) async {
    await _firestore.collection("users").add(
      {
        "uuid": uuid,
        "email": email,
        "username": username,
        "phone": phone,
        "birthdate": birthdate
      },
    );
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getProfile() async {
    var result = _firestore
        .collection("users")
        .where("uuid", isEqualTo: auth.currentUser!.uid);
    return result.get();
  }

  Future updatePassword(newPassword) async {
    try {
      await auth.currentUser!.updatePassword(newPassword);
      return true;
    } catch (ex) {
      throw Exception(ex);
    }
  }

  Future updateProfile(
      {required String email,
      required String username,
      required String phone,
      required String birthdate,
      required String id}) async {
    try {
      if( email != auth.currentUser!.email ){
        await auth.currentUser!.updateEmail(email);
      }
      await _firestore.collection("users").doc(id).update(
        {
          "email": email,
          "username": username,
          "phone": phone,
          "birthdate": birthdate
        },
      );
      return true;
    } catch (ex) {
      throw Exception(ex);
    }
  }
}
