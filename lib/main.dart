import 'package:flutter/material.dart';
import 'package:quesus/constants/colors.dart';
import 'package:quesus/pages/description_page.dart';
import 'package:quesus/pages/questions_page.dart';
import 'package:quesus/pages/result_page.dart';
import 'package:quesus/pages/signin_page.dart';
import 'package:quesus/pages/signup_page.dart';

import 'pages/main_page.dart';
import 'pages/users_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        scaffoldBackgroundColor: colorBackground,
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: colorGreenPrimary,
              error: colorRed,
              secondary: colorGreenSecondary,
              background: colorBackground,
            ),
        scrollbarTheme: const ScrollbarThemeData().copyWith(
          thumbColor: MaterialStateProperty.all(colorGreenSecondary),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(),
        '/signin': (context) => const SignIn(),
        '/signup': (context) => const SignUp(),
        '/description': (context) => const DescriptionPage(),
        '/results': (context) => const ResultPage(point: 0, maxPoint: 0),
        '/questions': (context) => const QuestionsPage(),
        '/users': (context) => const UsersPage(),
      },
    );
  }
}
