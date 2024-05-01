// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Patient _$PatientFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['pID', 'firstName', 'lastName'],
  );
  return Patient(
    json['pID'] as int,
    json['firstName'] as String,
    json['lastName'] as String,
    json['dOB'] as String?,
    json['height'] as int?,
    json['weight'] as int?,
    json['sport'] as String?,
    json['gender'] as String?,
    json['thirdPartyID'] as String?,
    (json['incidents'] as List<dynamic>?)
        ?.map((e) => Incident.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$PatientToJson(Patient instance) => <String, dynamic>{
      'pID': instance.pID,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'dOB': instance.dOB,
      'height': instance.height,
      'weight': instance.weight,
      'sport': instance.sport,
      'gender': instance.gender,
      'thirdPartyID': instance.thirdPartyID,
      'incidents': instance.incidents,
    };
