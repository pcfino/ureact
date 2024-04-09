// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reactive.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reactive _$ReactiveFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'rID',
      'fTime',
      'bTime',
      'lTime',
      'rTime',
      'mTime',
      'administeredBy',
      'tID'
    ],
  );
  return Reactive(
    json['rID'] as int,
    (json['fTime'] as num).toDouble(),
    (json['bTime'] as num).toDouble(),
    (json['lTime'] as num).toDouble(),
    (json['rTime'] as num).toDouble(),
    (json['mTime'] as num).toDouble(),
    json['administeredBy'] as String,
    json['tID'] as int,
  );
}

Map<String, dynamic> _$ReactiveToJson(Reactive instance) => <String, dynamic>{
      'rID': instance.rID,
      'fTime': instance.fTime,
      'bTime': instance.bTime,
      'lTime': instance.lTime,
      'rTime': instance.rTime,
      'mTime': instance.mTime,
      'administeredBy': instance.administeredBy,
      'tID': instance.tID,
    };
