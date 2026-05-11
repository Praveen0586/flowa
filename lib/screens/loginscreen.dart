



import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [

Text(
            'Flowa',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Text(
            'flow Through Your Day',
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),SizedBox(height: 30,),
          Text(
            'Welcome Back!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text("Sign in to continue",
              style: TextStyle(fontSize: 16, color: Colors.grey)),


              

          ],
        ),
      ),
    );
  }
}