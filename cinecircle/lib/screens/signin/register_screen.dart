import 'package:cinecircle/screens/home/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cinecircle/models/user.dart' as model;
import 'package:cinecircle/services/firestore_service.dart';

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

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
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

  void _onRegisterPressed() async {
    if (_formKey.currentState!.validate()) {
      _showLoadingDialog();

      final _status = await createAccount(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        username: usernameController.text.trim(),
      );

      Navigator.of(context).pop();

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

  Future<bool> checkIfUsernameExists(String username) async {
    final result = await _firestore
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
    return result.docs.isNotEmpty;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

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
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 183, 60, 254),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context), // Navigates back to Login
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB243C6), // Theme color
              Color(0xFF43C6FF), // Theme color
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 160.0, left: 24.0, right: 24.0, bottom: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Camera Icon
                Icon(Icons.movie_creation_outlined,
                    size: 100, color: Colors.white),

                SizedBox(height: 20),

                Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 30),

                // Input Fields
                _buildTextField(
                    controller: usernameController, label: "Username"),
                _buildTextField(controller: emailController, label: "Email"),
                _buildTextField(
                    controller: passwordController,
                    label: "Password",
                    obscureText: true),

                SizedBox(height: 20),

                // Register Button
                ElevatedButton(
                  onPressed: _onRegisterPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 60.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text("Register", style: TextStyle(fontSize: 18)),
                ),

                // Attribution Image (required by the api)
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Image.asset(
                    'assets/images/tmdb_attribution.png',
                    width: 100,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Custom Text Field
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.white70),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.white70),
          ),
        ),
        validator: (value) => value!.isEmpty ? "Please enter $label" : null,
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
