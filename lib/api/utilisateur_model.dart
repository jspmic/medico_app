import 'dart:convert';

UtilisateurModel utilisateurFromJson(String str) => UtilisateurModel.fromJson(json.decode(str));

String utilisateurToJson(UtilisateurModel data) => json.encode(data.toJson());

class UtilisateurModel {
    int? id;
    String? nom;
    DateTime? dateNaissance;
    String? sexe;
    String? email;
    String? numeroTelephone;
    String? province;
    String? commune;
    String? password;
    String? accessToken;

    UtilisateurModel({
        this.id,
        this.nom,
        this.sexe,
        this.dateNaissance,
        this.email,
        this.numeroTelephone,
        this.province,
        this.commune,
        this.password,
        this.accessToken,
    });

    factory UtilisateurModel.fromJson(Map<String, dynamic> json) => UtilisateurModel(
        id: json["id"],
        nom: json["nom"],
        sexe: json["sexe"],
        dateNaissance: json["dateNaissance"] == null ? null : DateTime.parse(json["dateNaissance"]),
        email: json["email"],
        numeroTelephone: json["numeroTelephone"],
        province: json["province"],
        commune: json["commune"],
        password: json["password"],
        accessToken: json["access_token"],
    );

    Map<String, dynamic> toJson() => {
        "nom": nom,
        "sexe": sexe,
        "dateNaissance": "${dateNaissance!.year.toString().padLeft(4, '0')}-${dateNaissance!.month.toString().padLeft(2, '0')}-${dateNaissance!.day.toString().padLeft(2, '0')}",
        "email": email ?? "",
        "numeroTelephone": numeroTelephone ?? "",
        "province": province,
        "commune": commune,
        "password": password,
    };
}
