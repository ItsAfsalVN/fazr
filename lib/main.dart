import 'package:fazr/screens/splash.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xff739077),
          primary: Color(0xff739077),
          error: Color(0xffC46363),
          secondary: Color(0xff4F6F52)
        ),
        scaffoldBackgroundColor: Color(0xffEDEFF4),
        fontFamily: 'Urbanist',
      ),
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
