import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  String? uid;
  late FirebaseAuth auth;

  @override
  void onInit() {
    auth = FirebaseAuth.instance;

    auth.authStateChanges().listen((event) {
      uid = event?.uid;
    });
    super.onInit();
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return {
        "error": false,
        "message": "Berhasil login",
      };
    } on FirebaseAuthException catch (e) {
      return {
        "error": true,
        "message": "${e.message}",
      };
    } catch (e) {
      return {
        "error": true,
        "message": "Tidak dapat login",
      };
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      await auth.signOut();
      return {
        "error": false,
        "message": "Berhasil logout",
      };
    } on FirebaseAuthException catch (e) {
      return {
        "error": true,
        "message": "${e.message}",
      };
    } catch (e) {
      return {
        "error": true,
        "message": "Tidak dapat logout",
      };
    }
  }
}
