import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quick_quiz/screens/dashboard_screen.dart';

import 'firebase_options.dart';

Future<void> main() async {
  //initilize first [firebase]
  WidgetsFlutterBinding.ensureInitialized();

  // add firebase option
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade200,
        appBarTheme: AppBarTheme(
          color: Colors.blueAccent.shade100,
          centerTitle: true,
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}
