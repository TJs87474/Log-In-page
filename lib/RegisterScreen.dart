import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'AuthService.dart';
import 'LoginScreen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      User? user = await _authService.registerWithEmail(
        _email.text,
        _password.text,
      );

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registered successfully. Please sign in.")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration failed")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
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
              ElevatedButton(onPressed: _register, child: Text("Register")),
            ],
          ),
        ),
      ),
    );
  }
}
