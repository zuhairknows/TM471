import 'package:barber_salon/routes.dart';
import 'package:barber_salon/theme/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'ui/home/home_page.dart';

late FirebaseAuth auth;
late FirebaseFirestore firestore;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  auth = FirebaseAuth.instance;
  firestore = FirebaseFirestore.instance;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      routes: Routes.routes,
      onGenerateRoute: Routes.onGenerateRoute,
      initialRoute: auth.currentUser == null ? Routes.AUTH : Routes.HOME,
    );
  }
}
