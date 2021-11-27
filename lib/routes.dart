import 'ui/home/home_page.dart';
import 'ui/register/view/login_page.dart';
import 'ui/register/view/register_page.dart';
import 'package:flutter/material.dart';

import 'ui/auth/view/auth_page.dart';
import 'ui/login/view/login_page.dart';

class Routes {
  Routes._();

  static const AUTH = 'auth';
  static const HOME = 'home';
  static const LOGIN = 'auth/login';
  static const REGISTER = 'auth/register';

  static final routes = {
    Routes.AUTH: (context) => const AuthPage(),
    Routes.HOME: (context) => const HomePage(),
    Routes.REGISTER: (context) => const RegisterPage(),
    Routes.LOGIN: (context) => const LoginPage(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {

  }
}