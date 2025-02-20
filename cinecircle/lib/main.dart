import 'package:cinecircle/screens/home/home_page.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'screens/signin/login_screen.dart';
//import 'screens/home/movie_list.dart';
// import 'firebase_options.dart'; TODO: fix firebase import

void main() async {
/*  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, 
  );
TODO: fix firebase initialization */
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
