import 'dart:convert';

RdvModel rdvFromJson(String str) => RdvModel.fromJson(json.decode(str));

String rdvToJson(RdvModel data) => json.encode(data.toJson());

class RdvModel {
    int? id;
    String? nom;
    String? sexe;
    String? contact;
    DateTime? datetime;
    String? hopital;
    String? service;
    int? idRef;

    RdvModel({
        this.id,
        this.nom,
        this.sexe,
        this.contact,
        this.datetime,
        this.hopital,
        this.service,
        this.idRef,
    });

    factory RdvModel.fromJson(Map<String, dynamic> json) => RdvModel(
        id: json["id"],
        nom: json["nom"],
        sexe: json["sexe"],
        contact: json["contact"],
        datetime: json["dateTime"] == null ? null : DateTime.parse(json["datetime"]),
        hopital: json["hopital"],
        service: json["service"],
    );

    Map<String, dynamic> toJson() => {
        "nom": nom,
        "sexe": sexe,
        "contact": sexe,
        "dateTime": datetime?.toIso8601String(),
        "hopital": hopital,
        "service": service,
        "reference_id": idRef,
    };
}
