import 'package:flutter/material.dart';
import 'package:socialapp/authentication/auth_page.dart';
import 'package:socialapp/direct_messages.dart';
import 'package:socialapp/firebase_options.dart';
import 'package:socialapp/user_profile.dart';
import 'home_feed.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
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
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AuthPage(),
        routes: {
          '/home': (context) => HomeFeedScreen(),
          '/profile': (context) => UserProfileScreen(),
          '/messages': (context) => DirectMessagesScreen(),
        });
  }
}
