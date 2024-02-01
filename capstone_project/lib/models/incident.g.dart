// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Incident _$IncidentFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['iID', 'iName', 'iDate', 'pID'],
  );
  return Incident(
    json['iID'] as int,
    json['iName'] as String,
    json['iDate'] as String,
    json['iNotes'] as String?,
    json['pID'] as int,
    (json['tests'] as List<dynamic>?)
        ?.map((e) => Test.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$IncidentToJson(Incident instance) => <String, dynamic>{
      'iID': instance.iID,
      'iName': instance.iName,
      'iDate': instance.iDate,
      'pID': instance.pID,
      'iNotes': instance.iNotes,
      'tests': instance.tests,
    };
