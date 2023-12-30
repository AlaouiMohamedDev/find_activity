import 'package:activite_group/list_activite.dart';
import 'package:activite_group/widget/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginEcran extends StatelessWidget {
  const LoginEcran({super.key});

  @override
  Widget build(BuildContext context) {
    String password = "";
     void updatePassword(String newPassword) {
      // Update the state of the parent widget
      password = newPassword;
    }
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInWidget(updatePasswordCallback: updatePassword);
        }
 
        String em ="em";
        em=snapshot.data!.email!;
        return ListActivite(currentIndex: 0,userEmail:em,password:password);
      },
    );
  }
}