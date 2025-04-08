import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _changePassword() async {
    try {
      if (_formKey.currentState!.validate()) {
        // Update password using FirebaseAuth
        await user?.updatePassword(_passwordController.text);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password changed successfully')),
        );
        
        // Clear the text field after successful change
        _passwordController.clear();
      }
    } catch (e) {
      // Handle errors (e.g., if password update fails)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to change password: ${e.toString()}')),
      );
    }
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/'); // Redirect to AuthenticationScreen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: user != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Welcome, ${user!.email}', style: TextStyle(fontSize: 24)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Add logic for editing the profile if needed
                    },
                    child: Text('Edit Profile'),
                  ),
                  SizedBox(height: 40),
                  Text('Change Password', style: TextStyle(fontSize: 20)),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(labelText: 'New Password'),
                            obscureText: true,
                            validator: (val) => val!.length < 6
                                ? 'Password must be at least 6 characters'
                                : null,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _changePassword,
                            child: Text('Change Password'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  // Flat Sign-out Button
                  ElevatedButton(
                    onPressed: _signOut,
                    child: Text(
                      'Sign Out',
                      style: TextStyle(
                      ),
                    ),
                  ),
                ],
              )
            : Text('No user is logged in.', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
