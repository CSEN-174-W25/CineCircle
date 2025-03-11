import 'package:cinecircle/screens/home/home_page.dart';
import 'package:cinecircle/screens/signin/login_screen.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'services/firestore_service.dart';
import 'models/user.dart' as model;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  model.User? currentUser;
  try {
    if (FirebaseAuth.instance.currentUser != null) {
      currentUser = await FirestoreService().getCurrentUserProfile();
    }
  } catch (e) {
    print('Error fetching user profile: $e');
  }

  runApp(MyApp(currentUser: currentUser));
}

class MyApp extends StatelessWidget {
  final model.User? currentUser;

  const MyApp({super.key, this.currentUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineCircle',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AuthCheck(currentUser: currentUser),
    );
  }
}

class AuthCheck extends StatelessWidget {
  final model.User? currentUser;

  const AuthCheck({super.key, this.currentUser});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData && currentUser != null) {
          return HomePage(user: currentUser!);
        }
        return LoginScreen();
      },
    );
  }
}
