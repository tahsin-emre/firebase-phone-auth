import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:phone_login/core/enums/auth_status.dart';

class AuthService {
  static var auth = FirebaseAuth.instance;
  static StreamController<AuthStatus> otpStream = StreamController();
  static String vid = '';

  static init() {
    otpStream.sink.add(AuthStatus.none);
  }

  static dispose() {
    otpStream.close();
  }

  static Future phoneVerify(String phoneNumber) async {
    await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 90),
        verificationCompleted: (credential) async {
          log('VERIFICATION_COMPLETE');
          await auth.signInWithCredential(credential);
          otpStream.sink.add(AuthStatus.success);
        },
        codeSent: (verificationId, token) {
          log('CODE_SENT');
          vid = verificationId;
          otpStream.sink.add(AuthStatus.codesent);
        },
        verificationFailed: (FirebaseAuthException e) {
          log('VERIFICATION_FAILED_${e.code}');
          otpStream.sink.add(AuthStatus.error);
        },
        codeAutoRetrievalTimeout: (a) {
          log('TIMEOUT_$a');
          otpStream.sink.add(AuthStatus.error);
        });
  }

  static Future otpVerify(String code) async {
    try {
      PhoneAuthCredential credential =
          PhoneAuthProvider.credential(verificationId: vid, smsCode: code);
      await auth.signInWithCredential(credential);
    } on Exception catch (e) {
      log('ERROR:OTP:$e');
      otpStream.sink.add(AuthStatus.error);
    }
  }
}
