import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:health_being_tips/features/forgotpassword/pages/forgot_pwd_page.dart';
import 'package:health_being_tips/features/login/pages/login_page.dart';
import 'package:health_being_tips/features/signup/pages/signup_page.dart';
import 'package:provider/provider.dart';

import 'features/home/widgets/home_provider.dart';
import 'features/splash/splash_page.dart';
import 'firebase_options.dart';
import 'auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyAuthProvider>(create: (_) => MyAuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashPage(),
        routes: {
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignUpPage(),
          '/forgot-password': (context) => ForgotPasswordPage(),
        },
      ),
    );
  }
}
