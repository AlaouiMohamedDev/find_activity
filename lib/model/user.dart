import 'package:cloud_firestore/cloud_firestore.dart';

class Utilisateur {
  String id;
  String email;
  String password;
  String adresse;
  String ville;
  DateTime anniversaire;
  int codePostal;

 Utilisateur({
    required this.id,
    required this.email,
    required this.password,
    required this.adresse,
    required this.ville,
    required this.anniversaire,
    required this.codePostal,
  });

  factory Utilisateur.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Utilisateur(
      id: doc.id,
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      adresse: data['adresse'] ?? '',
      ville: data['ville'] ?? '',
      anniversaire: data['anniversaire'] ??  '',
      codePostal: data['codePostal'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'adresse': adresse,
      'ville': ville,
      'anniversaire': anniversaire,
      'codePostal': codePostal,
    };
  }
}