import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trukapp/models/user_model.dart';
import 'package:trukapp/sessionmanagement/session_manager.dart';

class FirebaseHelper {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel> getCurrentUser({String uid}) async {
    String u = uid;
    if (uid == null) {
      User user = _auth.currentUser;
      u = user.uid;
    }

    CollectionReference reference = FirebaseFirestore.instance.collection("Users");

    final d = await reference.doc(u).get();
    if (d.exists) {
      return UserModel.fromSnapshot(d);
    }
    return null;
  }

  Future insertUser(
      String uid, String name, String email, String mobile, String company, String city, String state) async {
    int joiningTime = DateTime.now().millisecondsSinceEpoch;
    CollectionReference reference = FirebaseFirestore.instance.collection("Users");
    Map<String, dynamic> userData = {
      'uid': uid,
      'name': name,
      'email': email,
      'mobile': mobile,
      'company': company,
      'city': city,
      'state': state,
      'joining': joiningTime
    };
    await reference.doc(uid).set(userData);
    await SharedPref().createSession(uid, name, email, mobile);
  }
}
