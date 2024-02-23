// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_export.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientExport _$PatientExportFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['thirdPartyID'],
  );
  return PatientExport(
    json['thirdPartyID'] as String?,
    (json['incidents'] as List<dynamic>?)
        ?.map((e) => Incident.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$PatientExportToJson(PatientExport instance) =>
    <String, dynamic>{
      'thirdPartyID': instance.thirdPartyID,
      'incidents': instance.incidents,
    };
