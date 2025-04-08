import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'AuthService.dart';
import 'HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      User? user = await _authService.signInWithEmail(
        _email.text,
        _password.text,
      );

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign in failed")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign In")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _email,
                decoration: InputDecoration(labelText: "Email"),
                validator: (val) =>
                    val!.isEmpty ? "Please enter your email" : null,
              ),
              TextFormField(
                controller: _password,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (val) =>
                    val!.length < 6 ? "Password must be 6+ characters" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _signIn, child: Text("Sign In")),
            ],
          ),
        ),
      ),
    );
  }
}
