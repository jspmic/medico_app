import 'dart:convert';

// Utilisateur model to consume the GET /user response from the API

Utilisateur utilisateurFromJson(String str) => Utilisateur.fromJson(json.decode(str));

String utilisateurToJson(Utilisateur data) => json.encode(data.toJson());

class Utilisateur {
    int id;
    String nom;
    DateTime dateNaissance;
    String email;
    String numeroTelephone;
    String province;
    String commune;
    String password;
    String? accessToken;

    Utilisateur({
        required this.id,
        required this.nom,
        required this.dateNaissance,
        required this.email,
        required this.numeroTelephone,
        required this.province,
        required this.commune,
        required this.password,
        this.accessToken,
    });

    factory Utilisateur.fromJson(Map<String, dynamic> json) => Utilisateur(
        id: json["id"],
        nom: json["nom"],
        dateNaissance: DateTime.parse(json["dateNaissance"]),
        email: json["email"],
        numeroTelephone: json["numeroTelephone"],
        province: json["province"],
        commune: json["commune"],
        password: json["password"],
        accessToken: json["access_token"],
    );

    Map<String, dynamic> toJson() => {
        "nom": nom,
        "dateNaissance": "${dateNaissance.year.toString().padLeft(4, '0')}-${dateNaissance.month.toString().padLeft(2, '0')}-${dateNaissance.day.toString().padLeft(2, '0')}",
        "email": email,
        "numeroTelephone": numeroTelephone,
        "province": province,
        "commune": commune,
        "password": password,
        "access_token": accessToken ?? "",
    };
}
