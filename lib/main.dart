import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/authentication/auth_page.dart';
import 'package:socialapp/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:socialapp/theme/theme.dart';
import 'package:socialapp/theme/themePro.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(ChangeNotifierProvider(
      create: (context) => Themeprovider(),
      child: const MyApp(),
    ));
  } catch (e) {
    print('Error: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Social Media App Demo',
      theme: Provider.of<Themeprovider>(context).themeData,
      home: const AuthPage(),
    );
  }
}
