// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dynamic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dynamic _$DynamicFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'dID',
      't1Duration',
      't1TurnSpeed',
      't1MLSway',
      't2Duration',
      't2TurnSpeed',
      't2MLSway',
      't3Duration',
      't3TurnSpeed',
      't3MLSway',
      'dMax',
      'dMin',
      'dMean',
      'dMedian',
      'tsMax',
      'tsMin',
      'tsMean',
      'tsMedian',
      'mlMax',
      'mlMin',
      'mlMean',
      'mlMedian',
      'tID'
    ],
  );
  return Dynamic(
    json['dID'] as int,
    (json['t1Duration'] as num).toDouble(),
    (json['t1TurnSpeed'] as num).toDouble(),
    (json['t1MLSway'] as num).toDouble(),
    (json['t2Duration'] as num).toDouble(),
    (json['t2TurnSpeed'] as num).toDouble(),
    (json['t2MLSway'] as num).toDouble(),
    (json['t3Duration'] as num).toDouble(),
    (json['t3TurnSpeed'] as num).toDouble(),
    (json['t3MLSway'] as num).toDouble(),
    (json['dMax'] as num).toDouble(),
    (json['dMin'] as num).toDouble(),
    (json['dMean'] as num).toDouble(),
    (json['dMedian'] as num).toDouble(),
    (json['tsMax'] as num).toDouble(),
    (json['tsMin'] as num).toDouble(),
    (json['tsMean'] as num).toDouble(),
    (json['tsMedian'] as num).toDouble(),
    (json['mlMax'] as num).toDouble(),
    (json['mlMin'] as num).toDouble(),
    (json['mlMean'] as num).toDouble(),
    (json['mlMedian'] as num).toDouble(),
    json['tID'] as int,
  );
}

Map<String, dynamic> _$DynamicToJson(Dynamic instance) => <String, dynamic>{
      'dID': instance.dID,
      't1Duration': instance.t1Duration,
      't1TurnSpeed': instance.t1TurnSpeed,
      't1MLSway': instance.t1MLSway,
      't2Duration': instance.t2Duration,
      't2TurnSpeed': instance.t2TurnSpeed,
      't2MLSway': instance.t2MLSway,
      't3Duration': instance.t3Duration,
      't3TurnSpeed': instance.t3TurnSpeed,
      't3MLSway': instance.t3MLSway,
      'dMax': instance.dMax,
      'dMin': instance.dMin,
      'dMean': instance.dMean,
      'dMedian': instance.dMedian,
      'tsMax': instance.tsMax,
      'tsMin': instance.tsMin,
      'tsMean': instance.tsMean,
      'tsMedian': instance.tsMedian,
      'mlMax': instance.mlMax,
      'mlMin': instance.mlMin,
      'mlMean': instance.mlMean,
      'mlMedian': instance.mlMedian,
      'tID': instance.tID,
    };
