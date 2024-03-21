import 'package:flutter/material.dart';
import 'package:phone_login/core/constants/routes.dart';
import 'package:phone_login/core/enums/auth_status.dart';
import 'package:phone_login/core/services/auth_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController phoneCont = TextEditingController();
  final TextEditingController otpCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LOGIN'),
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<AuthStatus>(
            stream: AuthService.otpStream.stream,
            builder: (_, snapshot) {
              switch (snapshot.data) {
                case AuthStatus.none:
                  return phoneVerifyField();
                case AuthStatus.codesent:
                  return otpField();
                case AuthStatus.error:
                  return error();
                case AuthStatus.success:
                  Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
                  return Container();
                default:
                  return Container();
              }
            }),
      ],
    );
  }

  Widget phoneVerifyField() {
    return Column(
      children: [
        TextField(
          controller: phoneCont,
          decoration: const InputDecoration(hintText: '+905300387436'),
        ),
        ElevatedButton(
            onPressed: () {
              AuthService.phoneVerify(phoneCont.text);
            },
            child: const Text('Send Code')),
      ],
    );
  }

  Widget otpField() {
    return Column(
      children: [
        TextField(
          controller: otpCont,
          decoration: const InputDecoration(hintText: '*** ***'),
        ),
        ElevatedButton(
            onPressed: () {
              AuthService.otpVerify(otpCont.text);
            },
            child: const Text('Login')),
      ],
    );
  }

  Widget error() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: const Center(
        child: Text('Something Went Wrong'),
      ),
    );
  }

  @override
  void initState() {
    AuthService.init();
    super.initState();
  }

  @override
  void dispose() {
    AuthService.dispose();
    super.dispose();
  }
}
