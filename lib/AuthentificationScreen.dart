import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'AuthService.dart';
import 'HomeScreen.dart'; // Make sure this exists or create a simple placeholder screen

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool _isRegistering = true; // Toggle between registration and sign-in
  final AuthService _authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _toggleForm() {
    setState(() {
      _isRegistering = !_isRegistering;
    });
  }

  void _handleAuth() async {
    if (_formKey.currentState!.validate()) {
      User? user;
      if (_isRegistering) {
        user = await _authService.registerWithEmail(
          _emailController.text,
          _passwordController.text,
        );
        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration successful. Please sign in.')),
          );
          setState(() {
            _isRegistering = false; // Switch to sign-in screen
            _emailController.clear();
            _passwordController.clear();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration failed')),
          );
        }
      } else {
        user = await _authService.signInWithEmail(
          _emailController.text,
          _passwordController.text,
        );
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign-in failed')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isRegistering ? 'Register' : 'Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (val) => val!.isEmpty ? 'Enter your email' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (val) =>
                    val!.length < 6 ? 'Password must be 6+ characters' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleAuth,
                child: Text(_isRegistering ? 'Register' : 'Sign In'),
              ),
              TextButton(
                onPressed: _toggleForm,
                child: Text(
                  _isRegistering
                      ? 'Already have an account? Sign in'
                      : 'Don\'t have an account? Register',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
