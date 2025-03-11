import 'package:cinecircle/screens/home/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cinecircle/models/user.dart' as model;
import 'package:cinecircle/services/firestore_service.dart';

// Auth Exception Handler
enum AuthStatus {
  successful,
  wrongPassword,
  emailAlreadyExists,
  invalidEmail,
  weakPassword,
  unknown,
}

class AuthExceptionHandler {
  static AuthStatus handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case "invalid-email":
        return AuthStatus.invalidEmail;
      case "wrong-password":
        return AuthStatus.wrongPassword;
      case "weak-password":
        return AuthStatus.weakPassword;
      case "email-already-in-use":
        return AuthStatus.emailAlreadyExists;
      default:
        return AuthStatus.unknown;
    }
  }

  static String generateErrorMessage(AuthStatus error) {
    switch (error) {
      case AuthStatus.invalidEmail:
        return "Your email address appears to be invalid.";
      case AuthStatus.weakPassword:
        return "Your password must be at least 6 characters.";
      case AuthStatus.wrongPassword:
        return "Your email or password is incorrect.";
      case AuthStatus.emailAlreadyExists:
        return "The email address is already in use by another account.";
      default:
        return "An error occurred. Please try again later.";
    }
  }
}

// Register Screen
class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<AuthStatus> createAccount({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      if (await checkIfUsernameExists(username)) {
        return AuthStatus.emailAlreadyExists;
      }

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "userId": userCredential.user!.uid,
        "username": username,
        "email": email,
        'reviewedMedias': [],
        'averageRating': 0.0,
        'totalReviews': 0,
        'friends': [],
        'totalFriends': 0,
        'bio': '',
        'picUrl': 'asset:assets/images/placeholder.png',
        'recommendedMedia': {},
        "created_at": FieldValue.serverTimestamp(),
        'watchlist': [],
        'topFour': [],
        'pendingIncomingFriends': [],
        'pendingOutgoingFriends': [],
      });

      return AuthStatus.successful;
    } on FirebaseAuthException catch (e) {
      return AuthExceptionHandler.handleAuthException(e);
    } catch (e) {
      return AuthStatus.unknown;
    }
  }

  // Register Button Logic
  void _onRegisterPressed() async {
    if (_formKey.currentState!.validate()) {
      _showLoadingDialog();

      final _status = await createAccount(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        username: usernameController.text.trim(),
      );

      Navigator.of(context).pop(); // Hide loading dialog

      if (_status == AuthStatus.successful) {
        model.User? currentUser;
        if (FirebaseAuth.instance.currentUser != null) {
          currentUser = await FirestoreService().getCurrentUserProfile();
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(user: currentUser!)),
        );
      } else {
        final error = AuthExceptionHandler.generateErrorMessage(_status);
        _showSnackBar(error);
      }
    }
  }

  // Check if the username already exists in Firestore
  Future<bool> checkIfUsernameExists(String username) async {
    final result = await _firestore
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
    return result.docs.isNotEmpty;
  }

  // Display a SnackBar for error messages
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Show a Loading Dialog
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(labelText: "Username"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter a username" : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value!.isEmpty ? "Please enter a valid email" : null,
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (value) =>
                    value!.length < 6 ? "Password must be at least 6 characters" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _onRegisterPressed,
                child: Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }
}