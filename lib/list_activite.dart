import 'package:activite_group/add_activite.dart';
import 'package:activite_group/constant/images.dart';
import 'package:activite_group/profile.dart';
import 'package:activite_group/widget/activite_item.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:activite_group/model/activite.dart';

class ListActivite extends StatefulWidget {
  ListActivite({super.key, required this.currentIndex,required this.userEmail,required this.password});
  String userEmail;
  String password;
  int currentIndex;
  @override
  State<ListActivite> createState() => _ListActiviteState();
}

class _ListActiviteState extends State<ListActivite> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  String selectedFilter = "All";

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedFilter = "All";
    });
  }

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
          stream: db.collection('activite').snapshots(),
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

            List<Activite> activites = snapshot.data!.docs.map((doc) {
              return Activite.fromFirestore(doc);
            }).toList();

            List<Activite> filteredData = (selectedFilter == "All")
                ? activites
                : activites
                    .where((activity) => activity.categorie == selectedFilter)
                    .toList();

            return Column(
              children: [
                //BUTTON DE FILTER
                Container(
                  height: 30.0,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedFilter = "All";
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                          ),
                          child: Text(
                            "Tous",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedFilter = "sport";
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                          ),
                          child: Text(
                            "Sport",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedFilter = "shopping";
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                          ),
                          child: Text(
                            "Shopping",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) => ActiviteItem(
                      activite: filteredData[index],
                    ),
                  ),
                ),
              ],
            );
          },
        ));
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
             return AddActiviteWidget(currentIndex: 1,userEmail: widget.userEmail,password:widget.password);
            }));
          }

          if (index == 2) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
             return ProfileWidget(currentIndex: 2,userEmail: widget.userEmail,password:widget.password);
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
}
