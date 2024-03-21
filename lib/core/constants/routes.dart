import 'package:flutter/material.dart';
import 'package:phone_login/ui/auth/login_view.dart';
import 'package:phone_login/ui/home/home_view.dart';

class Routes {
  static const String login = '/login';
  static const String home = '/home';

  static Route<dynamic> onGenerateRoute(RouteSettings rs) {
    Widget page = Container();
    switch (rs.name) {
      case login:
        page = const LoginView();
      case home:
        page = const HomeView();
      default:
        page = Container();
    }
    return MaterialPageRoute(builder: (_) => page, settings: rs);
  }
}
