import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

// Model classes

@JsonSerializable()
class User {
	String nom = "";
	String sexe = "";
	String province = "";
	String commune = "";
	String? tel;
	String? email;
	String? nomReference;
	String? telReference;
	String? emailReference;

	User(this.nom, this.sexe, this.province,
		this.commune, this.tel, this.email,
		this.nomReference, this.telReference,
		this.emailReference);

	factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
	Map<String, dynamic> toJson() => _$UserToJson(this);
}

