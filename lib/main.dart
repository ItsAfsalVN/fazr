// main.dart

import 'package:fazr/firebase_options.dart';
import 'package:fazr/providers/completed_task_provider.dart';
import 'package:fazr/providers/date_provider.dart';
import 'package:fazr/providers/task_provider.dart';
import 'package:fazr/screens/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main(List<String> args) async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => TaskProvider()),
        ChangeNotifierProvider(create: (ctx) => DateProvider()),
        ChangeNotifierProvider(create: (ctx) => CompletedTaskProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xff739077),
            primary: const Color(0xff739077),
            error: const Color(0xffC46363),
            secondary: const Color(0xff4F6F52),
          ),
          scaffoldBackgroundColor: const Color(0xffEDEFF4),
          fontFamily: 'Urbanist',
        ),
        debugShowCheckedModeBanner: false,
        home: const Splash(),
      ),
    );
  }
}
