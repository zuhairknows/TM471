import 'package:flutter/material.dart';

import 'ui/auth/view/auth_page.dart';
import 'ui/bookings/bookings_page.dart';
import 'ui/feedback/feedback_page.dart';
import 'ui/forgot_password/forgot_password_page.dart';
import 'ui/home/home_page.dart';
import 'ui/login/login_page.dart';
import 'ui/profile/profile_page.dart';
import 'ui/register/register_page.dart';
import 'ui/salon/salon_page.dart';
import 'ui/salons_list/salons_list_page.dart';

class Routes {
  Routes._();

  static const AUTH = 'auth';
  static const HOME = 'home';
  static const LOGIN = 'auth/login';
  static const REGISTER = 'auth/register';
  static const FORGOT_PASSWORD = 'auth/forgot_password';
  static const SALONS = 'salons';
  static const SALON = 'salons/';
  static const PROFILE = 'profile';
  static const BOOKINGS = 'bookings';

  static salonRoute(String id) => "salons/$id";

  static salonFeedbackRoute(String id) => "salons/$id/feedback";

  static final routes = {
    Routes.AUTH: (context) => const AuthPage(),
    Routes.HOME: (context) => HomePage(),
    Routes.REGISTER: (context) => const RegisterPage(),
    Routes.LOGIN: (context) => const LoginPage(),
    Routes.FORGOT_PASSWORD: (context) => const ForgotPasswordPage(),
    Routes.SALONS: (context) => const SalonsListPage(),
    Routes.PROFILE: (context) => const ProfilePage(),
    Routes.BOOKINGS: (context) => const BookingsPage(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name!.startsWith('salons/')) {
      final salonId = settings.name!.split('/')[1];

      if (settings.name!.endsWith('feedback')) {
        return MaterialPageRoute(builder: (context) => FeedbackPage(salonId));
      } else {
        return MaterialPageRoute(builder: (context) => SalonPage(salonId));
      }
    }
  }
}
