import 'package:json_annotation/json_annotation.dart';

/// This allows the `Dynamic` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'dynamic.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class Dynamic {
  Dynamic(
    this.dID,
    this.t1Duration,
    this.t1TurnSpeed,
    this.t1MLSway,
    this.t2Duration,
    this.t2TurnSpeed,
    this.t2MLSway,
    this.t3Duration,
    this.t3TurnSpeed,
    this.t3MLSway,
    this.dMax,
    this.dMin,
    this.dMean,
    this.dMedian,
    this.tsMax,
    this.tsMin,
    this.tsMean,
    this.tsMedian,
    this.mlMax,
    this.mlMin,
    this.mlMean,
    this.mlMedian,
    this.administeredBy,
    this.tID,
  );

  @JsonKey(required: true)
  int dID;

  @JsonKey(required: true)
  double t1Duration;

  @JsonKey(required: true)
  double t1TurnSpeed;

  @JsonKey(required: true)
  double t1MLSway;

  @JsonKey(required: true)
  double t2Duration;

  @JsonKey(required: true)
  double t2TurnSpeed;

  @JsonKey(required: true)
  double t2MLSway;

  @JsonKey(required: true)
  double t3Duration;

  @JsonKey(required: true)
  double t3TurnSpeed;

  @JsonKey(required: true)
  double t3MLSway;

  @JsonKey(required: true)
  double dMax;

  @JsonKey(required: true)
  double dMin;

  @JsonKey(required: true)
  double dMean;

  @JsonKey(required: true)
  double dMedian;

  @JsonKey(required: true)
  double tsMax;

  @JsonKey(required: true)
  double tsMin;

  @JsonKey(required: true)
  double tsMean;

  @JsonKey(required: true)
  double tsMedian;

  @JsonKey(required: true)
  double mlMax;

  @JsonKey(required: true)
  double mlMin;

  @JsonKey(required: true)
  double mlMean;

  @JsonKey(required: true)
  double mlMedian;

  @JsonKey(required: true)
  String administeredBy;

  @JsonKey(required: true)
  int tID;

  /// A necessary factory constructor for creating a new Dynamic instance
  /// from a map. Pass the map to the generated `_$DynamicFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Incident.
  factory Dynamic.fromJson(Map<String, dynamic> json) =>
      _$DynamicFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$DynamicToJson`.
  Map<String, dynamic> toJson() => _$DynamicToJson(this);
}
