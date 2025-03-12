import 'package:cinecircle/screens/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cinecircle/screens/signin/register_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cinecircle/models/user.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _signIn() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() => _errorMessage = "Please enter both email and password.");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      auth.UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        setState(() => _errorMessage = "No profile data found.");
        return;
      }

      final loggedInUser = User.fromJson(userDoc.data()!);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(user: loggedInUser)),
      );

    } on auth.FirebaseAuthException catch (e) {
      setState(() => _errorMessage = _getAuthErrorMessage(e.code));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    if (emailController.text.isEmpty) {
      setState(() => _errorMessage = "Please enter your email.");
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: emailController.text.trim());
      setState(() => _errorMessage = "Password reset link sent to your email.");
    } on auth.FirebaseAuthException catch (e) {
      setState(() => _errorMessage = _getAuthErrorMessage(e.code));
    }
  }

  String _getAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return "No account found for this email.";
      case 'wrong-password':
        return "Incorrect password.";
      case 'invalid-email':
        return "Invalid email format.";
      case 'too-many-requests':
        return "Too many login attempts. Try again later.";
      case 'network-request-failed':
        return "Check your internet connection.";
      default:
        return "Login failed. Please try again.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFF3B3B),
              Color(0xFFC200A1)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 160.0, left: 24.0, right: 24.0, bottom: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon and Header
              Icon(Icons.movie, size: 100, color: Colors.white),
              Text(
                'CineCircle',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 30),

              // Email Field
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 15),

              // Password Field
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                obscureText: true,
              ),

              if (_errorMessage.isNotEmpty) ...[
                SizedBox(height: 10),
                Text(_errorMessage, style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255))),
              ],

              SizedBox(height: 20),

              // Sign In Button
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _signIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 52, 52),
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Sign In'),
                    ),

              // Register Button
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                },
                child: Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(color: Colors.white),
                ),
              ),

              // Forgot Password
              TextButton(
                onPressed: _resetPassword,
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100.0, left: 24.0, right: 24.0),
                child: Image.asset(
                  'assets/images/tmdb_attribution.png',
                  width: 150.0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
