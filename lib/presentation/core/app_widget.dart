import 'package:flutter/material.dart';
import 'package:flutter_ddd_firebase/presentation/sign_in/sign_in_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Notes app",
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.light(
          primary: Colors.green[800]!,
          secondary: Colors.blueAccent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
      home: const SignInPage(),
    );
  }
}
