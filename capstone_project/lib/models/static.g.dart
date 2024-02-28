// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'static.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Static _$StaticFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'sID',
      'tlSolidML',
      'tlFoamML',
      'slSolidML',
      'slFoamML',
      'tandSolidML',
      'tandFoamML',
      'tID'
    ],
  );
  return Static(
    json['sID'] as int,
    (json['tlSolidML'] as num).toDouble(),
    (json['tlFoamML'] as num).toDouble(),
    (json['slSolidML'] as num).toDouble(),
    (json['slFoamML'] as num).toDouble(),
    (json['tandSolidML'] as num).toDouble(),
    (json['tandFoamML'] as num).toDouble(),
    json['tID'] as int,
  );
}

Map<String, dynamic> _$StaticToJson(Static instance) => <String, dynamic>{
      'sID': instance.sID,
      'tlSolidML': instance.tlSolidML,
      'tlFoamML': instance.tlFoamML,
      'slSolidML': instance.slSolidML,
      'slFoamML': instance.slFoamML,
      'tandSolidML': instance.tandSolidML,
      'tandFoamML': instance.tandFoamML,
      'tID': instance.tID,
    };
