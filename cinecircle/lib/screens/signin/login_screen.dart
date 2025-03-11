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
    // Firebase Authentication
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

  // A list of possible error messages
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
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (_errorMessage.isNotEmpty) ...[
              SizedBox(height: 10),
              Text(_errorMessage, style: TextStyle(color: Colors.red)),
            ],
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _signIn,
                    child: Text('Sign In'),
                  ),
            TextButton(
                onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()),
);
              },
              child: Text("Don't have an account? Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}
