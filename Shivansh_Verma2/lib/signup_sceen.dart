import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shivansh_verma2/login_screen.dart';
import 'package:shivansh_verma2/services/auth_services.dart';

class SignupScreen extends StatelessWidget {
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white38,
        foregroundColor: Colors.white,
        title: Text('Create Account'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 50),
              Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Register Here',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 40),
              TextField(
                controller: _emailController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white60),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: Colors.white60,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passController,
                style: TextStyle(color: Colors.white),
                obscureText: true,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white60),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: Colors.white60,
                  ),
                ),
              ),
              SizedBox(height: 50),
              SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      if (!isValidEmail(_emailController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please enter a valid email address.')),
                        );
                        return;
                      }
                      User? user = await _auth.registerWithEmailAndPassword(
                        _emailController.text,
                        _passController.text,
                      );
                      if (user != null) {
                        if (!user.emailVerified) {
                          await user.sendEmailVerification();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Verification email sent.')),
                          );
                        }
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('OR', style: TextStyle(color: Colors.white)),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  User? user = await _auth.signInWithGoogle();
                  if (user != null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Google Sign-Up failed.')),
                    );
                  }
                },
                icon: Icon(Icons.account_circle, color: Colors.black),
                label: Text(
                  'Sign Up with Google',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 18, color: Colors.white30),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}