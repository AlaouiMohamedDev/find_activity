import 'package:firebase_auth/firebase_auth.dart';
import 'package:activite_group/constant/images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

TextEditingController emailC = TextEditingController();
TextEditingController passC = TextEditingController();

class SignInWidget extends StatefulWidget {
  final void Function(String) updatePasswordCallback;
   SignInWidget({super.key,required this.updatePasswordCallback});

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Image.asset(logo, width: 70),
      ),
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                  controller: emailC,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'type ur Email Here',
                      prefixIcon: Icon(Icons.email)))),
          Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                  controller: passC,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'type your password Here',
                      prefixIcon: Icon(Icons.lock)))),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    UserCredential userCredential =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailC.text,
                      password: passC.text,
                    );
                   widget.updatePasswordCallback(passC.text);
                    emailC.clear();
                    passC.clear();
                    // If sign-in is successful, you can access user information using userCredential.user
                    print("Sign-in successful: ${userCredential.user?.email}");

                  } catch (e) {
                    // If sign-in fails, you can handle the error here
                    print("Error signing in: $e");
                  }
                },
                child: Text("Se connecter"),
              ))
        ],
      ),
    );
  }
}
