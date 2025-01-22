import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shivansh_verma2/home_screen.dart';
import 'package:shivansh_verma2/services/auth_services.dart';
import 'package:shivansh_verma2/signup_sceen.dart';
import 'package:shivansh_verma2/forgot_pass_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black12,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.orange,
          foregroundColor: Colors.black,
          title: Text('Sign In'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(height: 50),
                Text(
                  'Welcome Back',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500, color: Colors.white),
                ),
                SizedBox(height: 5),
                Text(
                  'Login Here',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
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
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    labelText: 'Email',
                    labelStyle: TextStyle(color: const Color.fromARGB(255, 224, 202, 121)),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passController,
                  style: TextStyle(color: Colors.white),
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white60),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    labelText: 'Password',
                    labelStyle: TextStyle(color: const Color.fromARGB(255, 224, 202, 121)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: const Color.fromARGB(255, 224, 202, 121),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPassScreen()), // Navigate to Forgot Password
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        User? user = await _auth.signInWithEmailAndPassword(
                          _emailController.text,
                          _passController.text,
                        );

                        if (user != null) {
                          if (user.emailVerified) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => HomeScreen()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please verify your email first.')),
                            );
                          }
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    },
                    child: Text(
                      'Log In',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text('OR', style: TextStyle(color: Colors.orange)),
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
                    'Continue with Google',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                ),
                SizedBox(height: 30),
                Text(
                  "Don't have an account?",
                  style: TextStyle(color: Colors.amber),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
                  },
                  child: Text(
                    'Create Account',
                    style: TextStyle(fontSize: 18, color: Colors.white30),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}