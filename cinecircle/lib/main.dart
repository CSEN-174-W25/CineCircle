import 'package:cinecircle/screens/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'screens/signin/login_screen.dart';
//import 'screens/home/movie_list.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineCircle',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
      // home: AuthCheck(), TODO: Add auth check
    );
  }
}

/* class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()), 
          );
        }
        if (snapshot.hasData) {
          return MovieListScreen();
        }
        return LoginScreen();
      },
    );
  }
}
TODO: api */
