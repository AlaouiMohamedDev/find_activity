import 'package:activite_group/add_activite.dart';
import 'package:activite_group/constant/images.dart';
import 'package:activite_group/list_activite.dart';
import 'package:activite_group/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProfileWidget extends StatefulWidget {
  ProfileWidget(
      {super.key,
      required this.currentIndex,
      required this.userEmail,
      required this.password});
  int currentIndex;
  String userEmail;
  String password;
  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  FirebaseFirestore db = FirebaseFirestore.instance;
 TextEditingController passC  = TextEditingController();
  TextEditingController addressC = TextEditingController();
  TextEditingController codePostaleC = TextEditingController();

  void getUserInfo() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userEmail)
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        print(data);

        addressC.text = data["adresse"];
        codePostaleC.text = data["codePostale"].toString();

      } else {
        print('Document not found');
      }
    } catch (e) {
      print('Error getting document: $e');
    }
  }
  @override
void initState() {
  super.initState();
  }

int check = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Image.asset(logo, width: 70),
          actions: [
            InkWell(
              onTap: () async => {await _signOut(context)},
              child: Container(
                width: 100,
                color: Colors.red,
                child: Center(
                  child: Text(
                    "Se déconnecter",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          color: Colors
              .red, // Set the background color of the bottom app bar to blue
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6, top: 4),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomNavItem(Icons.sports_soccer, 'Activité', 0),
                _buildBottomNavItem(Icons.add, 'Ajouter', 1),
                _buildBottomNavItem(Icons.person, 'person', 2),
              ],
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: db.collection('users').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Une erreur est survenue'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

            if(check == 0)
            {
              getUserInfo();
              passC.text = widget.password;
              check =1;
            }
            
              return Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Login:',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            widget.userEmail,
                            style: TextStyle(fontSize: 18),
                          ),
                        ]),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Password:',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: passC,
                      enabled: false,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter votre password ',
                        border: OutlineInputBorder(),
                      ),
                    ),
                     SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Adresse:',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: addressC,
                      decoration: InputDecoration(
                        hintText: 'Enter votre Adresse',
                        border: OutlineInputBorder(),
                      ),
                    ),
                     SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Code Postale:',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: codePostaleC,
                      decoration: InputDecoration(
                        hintText: 'Enter votre Code Postale',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              );
            }));
  }

  Widget _buildBottomNavItem(IconData iconData, String label, int index) {
    return Container(
      color: widget.currentIndex == index ? Colors.white : Colors.red,
      child: InkWell(
        onTap: () {
          setState(() {
            widget.currentIndex = index;
          });

          if (index == 1) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return AddActiviteWidget(
                  currentIndex: 1,
                  userEmail: widget.userEmail,
                  password: widget.password);
            }));
          }

          if (index == 0) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ListActivite(
                  currentIndex: 0,
                  userEmail: widget.userEmail,
                  password: widget.password);
            }));
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              color: widget.currentIndex == index ? Colors.red : Colors.white,
            ),
            SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: widget.currentIndex == index ? Colors.red : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      // Sign out the current user
      await FirebaseAuth.instance.signOut();
      print("User signed out");
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return LoginEcran();
      }));
      // Navigate to the login or home screen, or perform any other necessary actions
      // For example, you can use Navigator to go back to the login screen:
      // Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      // Handle sign-out errors
      print("Error signing out: $e");
    }
  }

  Future<Map<String, dynamic>?> getDataById(String userId) async {
    try {
      DocumentSnapshot documentSnapshot = (await FirebaseFirestore.instance
          .collection('users')
          .snapshots()) as DocumentSnapshot<Object?>;

      if (documentSnapshot.exists) {
        // Document exists, you can access its data
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        print("User data: $data");
        return data;
      } else {
        print("Document does not exist");
        return null;
      }
    } catch (e) {
      print("Error getting document by ID");
    }
  }
}
