import 'package:cinecircle/screens/home/home_page.dart';
import 'package:cinecircle/screens/signin/login_screen.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineCircle',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AuthCheck(), // ✅ Use AuthCheck to manage authentication state
    );
  }
}

// ✅ Authentication Check Widget
class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()), // Loading indicator
          );
        }
        if (snapshot.hasData) {
          return HomePage(); // User is logged in, go to HomePage
        }
        return LoginScreen(); // User is NOT logged in, go to LoginScreen
      },
    );
  }
}
