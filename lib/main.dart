import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:to_do_list/forgot_password.dart';
import 'package:to_do_list/to_do_list.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle,
              size: 175.0,
              color: Colors.grey[400],
            ),
            Container(
              width: 300.0,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: TextField(
                controller: usernameController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Container(
              width: 300.0,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: GestureDetector(
                child: Text(
                  'Forgot Password',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: usernameController.text, password: passwordController.text)
                .then((value) {
                  usernameController.clear();
                  passwordController.clear();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ToDoListPage(uid: value.user!.uid)),
                  );
                }).catchError((error){
                  print(error.toString());
                });
              },
              child: Text(
                'Sign in',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: usernameController.text, password: passwordController.text)
                .then((value) {
                  print("Successfully signed up the user!");
                  usernameController.clear();
                  passwordController.clear();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ToDoListPage(uid: value.user!.uid)),
                  );
                }).catchError((error){
                  print(error.toString());
                });
              },
              child: Text(
                'Sign up',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}