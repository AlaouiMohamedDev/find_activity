import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;


class Storage{
  final FirebaseStorage storage =FirebaseStorage.instance;

  Future<String> uploadFile(String filePath, String fileName)async{
    File file = File(filePath);

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImage = referenceRoot.child('image');

    Reference referenceImageToUpload = referenceDirImage.child(fileName);

    try{
      await referenceImageToUpload.putFile(file);
      return await referenceImageToUpload.getDownloadURL();
    }
    catch(e){
      print(e);
      return "Error";
    }
  }
}