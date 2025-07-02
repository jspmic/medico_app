import 'dart:convert';

RDV rdvFromJson(String str) => RDV.fromJson(json.decode(str));

String rdvToJson(RDV data) => json.encode(data.toJson());

class RDV {
    int? id;
    String? nom;
    String? sexe;
    String? contact;
    DateTime? datetime;
    String? hopital;
    String? service;
    int? idRef;

    RDV({
        this.id,
        this.nom,
        this.sexe,
        this.contact,
        this.datetime,
        this.hopital,
        this.service,
        this.idRef,
    });

    factory RDV.fromJson(Map<String, dynamic> json) => RDV(
        id: json["id"],
        nom: json["nom"],
        sexe: json["sexe"],
        contact: json["contact"],
        datetime: json["datetime"] == null ? null : DateTime.parse(json["datetime"]),
        hopital: json["hopital"],
        service: json["service"],
    );

    Map<String, dynamic> toJson() => {
        "nom": nom,
        "sexe": sexe,
        "contact": sexe,
        "datetime": datetime?.toIso8601String(),
        "hopital": hopital,
        "service": service,
        "reference_id": idRef,
    };
}
