import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:marworx_flutter_task/Ui/login_screen.dart';

import 'package:marworx_flutter_task/firebase_options.dart';
import 'package:marworx_flutter_task/providers/job_provider.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, 
  );
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => JobProvider()),
      ],
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
