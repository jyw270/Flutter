import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:to_do_list/main.dart';
import 'package:to_do_list/to_do_list.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Receive an email to rest your password.'),
            Container(
              width: 300.0,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: TextField(
                controller: emailController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.sendPasswordResetEmail(
                    email: emailController.text.trim())
                .then((value) {
                  emailController.clear();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                }).catchError((error){
                  print(error.toString());
                });
              },
              child: Text(
                'Reset Password',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
          ],
        ),
    )
    );
  }
}