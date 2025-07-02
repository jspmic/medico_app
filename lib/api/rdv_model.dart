import 'dart:convert';

RdvModel rdvFromJson(String str) => RdvModel.fromJson(json.decode(str));

String rdvToJson(RdvModel data) => json.encode(data.toJson());

class RdvModel {
    int? id;
    String? nom;
    String? sexe;
    String? contact;
    String? province;
    String? commune;
    DateTime? datetime;
    String? hopital;
    String? service;
    int? idRef;

    RdvModel({
        this.id,
        this.nom,
        this.sexe,
        this.contact,
        this.province,
        this.commune,
        this.datetime,
        this.hopital,
        this.service,
        this.idRef,
    });

    factory RdvModel.fromJson(Map<String, dynamic> json) => RdvModel(
        id: json["id"],
        nom: json["nom"],
        sexe: json["sexe"],
        contact: json["contact"] == "null" ? null: json["contact"],
        province: json["province"] == "null" ? null: json["province"],
        commune: json["commune"] == "null" ? null: json["commune"],
        datetime: json["dateTime"] == null ? null : DateTime.parse(json["dateTime"]),
        hopital: json["hopital"],
        service: json["service"],
        idRef: json["reference_id"],
    );

    Map<String, dynamic> toJson() {
		if (province == null || commune == null) {
			return {
				"nom": nom,
				"sexe": sexe,
				"contact": contact,
				"dateTime": datetime?.toIso8601String(),
				"hopital": hopital,
				"service": service,
				"reference_id": idRef,
			};
		}
		return {
			"nom": nom,
			"sexe": sexe,
			"contact": contact,
			"province": province,
			"commune": commune,
			"dateTime": datetime?.toIso8601String(),
			"hopital": hopital,
			"service": service,
			"reference_id": idRef,
		};
	}
}
