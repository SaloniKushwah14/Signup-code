import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:sign4/Phone_authpage.dart';

import 'Signup_Page2.dart';

// or wherever your home page is

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // ✅ Don't forget await!
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => SignUp()),
          GetPage(name: '/phone', page: () => PhoneAuthpage()),
        ]
    );
  }
}


