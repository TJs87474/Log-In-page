import 'package:flutter/material.dart';
import 'AuthService.dart'; // Make sure AuthService is imported

class HomeScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushReplacementNamed(context, '/'); // Redirect to the authentication screen
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'You are logged in!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
