// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  json['nom'] as String,
  json['sexe'] as String,
  json['province'] as String,
  json['commune'] as String,
  json['tel'] as String?,
  json['email'] as String?,
  json['nomReference'] as String?,
  json['telReference'] as String?,
  json['emailReference'] as String?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'nom': instance.nom,
  'sexe': instance.sexe,
  'province': instance.province,
  'commune': instance.commune,
  'tel': instance.tel,
  'email': instance.email,
  'nomReference': instance.nomReference,
  'telReference': instance.telReference,
  'emailReference': instance.emailReference,
};
