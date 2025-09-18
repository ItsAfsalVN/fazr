import 'package:fazr/firebase_options.dart';
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
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xff739077),
            primary: Color(0xff739077),
            error: Color(0xffC46363),
            secondary: Color(0xff4F6F52),
          ),
          scaffoldBackgroundColor: Color(0xffEDEFF4),
          fontFamily: 'Urbanist',
        ),
        debugShowCheckedModeBanner: false,
        home: Splash(),
      ),
    );
  }
}
