import 'dart:io';
import 'package:activite_group/list_activite.dart';
import 'package:quickalert/quickalert.dart';
import 'package:activite_group/constant/images.dart';
import 'package:activite_group/model/activite.dart';
import 'package:activite_group/model/storage.dart';
import 'package:activite_group/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';

class AddActiviteWidget extends StatefulWidget {
  AddActiviteWidget(
      {super.key, required this.currentIndex, required this.userEmail,required this.password});
  int currentIndex;
  String userEmail;
  String password;

  @override
  State<AddActiviteWidget> createState() => _AddActiviteWidgetState();
}

class _AddActiviteWidgetState extends State<AddActiviteWidget> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Storage storage = new Storage();

  TextEditingController titreC = TextEditingController();
  TextEditingController lieuC = TextEditingController();
  TextEditingController prixC = TextEditingController();
  TextEditingController nbrPersonMinC = TextEditingController();

  TextEditingController categoryC = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  File? file;
  var _recognitions;
  var category = "other";
  //var dataList = [];
  @override
  void initState() {
    super.initState();
    loadmodel().then((value) {
      setState(() {});
    });
  }

  loadmodel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        file = File(image!.path);
      });
      detectimage(file!);
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future detectimage(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _recognitions = recognitions;
      category = _recognitions[0]['label'];

      int spaceIndex = category.indexOf(' ');

      if (spaceIndex != -1 && spaceIndex < category.length - 1) {
        String result = category.substring(spaceIndex + 1);

        categoryC.text = result;
      }
    });
  }

  void saveActivite() async {
    String fileUrl =
        "${DateTime.now().millisecondsSinceEpoch}.${file!.path.split('.').last}";

    if (file != null) {
      storage.uploadFile(file!.path, fileUrl).then((value) {
        if (value.isNotEmpty &&
            titreC.text.isNotEmpty &&
            lieuC.text.isNotEmpty &&
            prixC.text.isNotEmpty &&
            categoryC.text.isNotEmpty &&
            nbrPersonMinC.text.isNotEmpty) {
          Activite activite = Activite(
            titre: titreC.text,
            lieu: lieuC.text,
            prix: double.parse(prixC.text),
            categorie: categoryC.text,
            image: value,
            nbrPersonMin: int.parse(nbrPersonMinC.text),
          );

          Map<String, dynamic> data = activite.toJson();

          print(data);

          db.collection('activite').add(data);

          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Activity added Successfully!',
          );

          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ListActivite(currentIndex: 0, userEmail: widget.userEmail,password:widget.password);
          }));

           QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Activity added Successfully!',
          );
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Oops...',
            text: 'Sorry, something went wrong',
          );
        }
      });
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'Sorry, something went wrong',
      );
    }
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
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(10, 8, 10, 10),
          child: Center(
            child: Column(children: [
              Text(
                'Titre:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              TextField(
                controller: titreC,
                decoration: InputDecoration(
                  hintText: 'Enter un titre ',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Lieu:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              TextField(
                controller: lieuC,
                decoration: InputDecoration(
                  hintText: 'Enter un Lieu ',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(height: 10),
              Text(
                'Prix',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              TextField(
                controller: prixC,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter a prix',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Nombre de personne minimum:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              TextField(
                controller: nbrPersonMinC,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter a number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Categorie:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              TextField(
                enabled: false,
                controller: categoryC,
                decoration: InputDecoration(
                  hintText: ' ',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Column(
                children: <Widget>[
                  if (_image != null)
                    Image.file(
                      File(_image!.path),
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    )
                  else
                    Text("Aucun image selectionner"),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Pick Image from Gallery'),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: saveActivite,
                child: Text('Add Activte'),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData iconData, String label, int index) {
    return Container(
      color: widget.currentIndex == index ? Colors.white : Colors.red,
      child: InkWell(
        onTap: () {
          setState(() {
            widget.currentIndex = index;
          });

           if (index == 0) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ListActivite(
                  currentIndex: 2, userEmail: widget.userEmail,password:widget.password);
            }));
          }

          if (index == 2) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ProfileWidget(
                  currentIndex: 2, userEmail: widget.userEmail,password:widget.password);
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
