import 'package:activite_group/model/activite.dart';
import 'package:flutter/material.dart';
import 'package:activite_group/constant/images.dart';

class ActiviteDetail extends StatefulWidget {
  ActiviteDetail({super.key,required this.activite});
  Activite activite;

  @override
  State<ActiviteDetail> createState() => _ActiviteDetailState();
}

class _ActiviteDetailState extends State<ActiviteDetail> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Image.asset(logo, width: 70),
          leading: IconButton(
            icon: Icon(Icons.arrow_back,color: Colors.red),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      
        body:SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Image.network(widget.activite.image),
                SizedBox(height:0),
                Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: const Color.fromARGB(255, 214, 214, 214))),
              ),
              
              child: Row(
                children: [
                  Text(
                    'Titre',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 10.0), // Add spacing between texts
                  Text(
                    widget.activite.titre,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
               Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: const Color.fromARGB(255, 214, 214, 214))),
              ),
              
              child: Row(
                children: [
                  Text(
                    'Lieu',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 10.0), // Add spacing between texts
                  Text(
                    widget.activite.lieu,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
               Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: const Color.fromARGB(255, 214, 214, 214))),
              ),
              
              child: Row(
                children: [
                  Text(
                    'Categorie : ',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 10.0), // Add spacing between texts
                  Text(
                    widget.activite.categorie,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
               Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: const Color.fromARGB(255, 214, 214, 214))),
              ),
              
              child: Row(
                children: [
                  Text(
                    'Prix :',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 10.0), // Add spacing between texts
                  Text(
                    widget.activite.prix.toString(),
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
                 Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: const Color.fromARGB(255, 214, 214, 214))),
              ),
              
              child: Row(
                children: [
                  Text(
                    'Nombre de personne minimum :',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 10.0), // Add spacing between texts
                  Text(
                    widget.activite.nbrPersonMin.toString(),
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            ]),
          ),
        )
        );
  }

}