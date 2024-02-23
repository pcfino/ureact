import 'package:json_annotation/json_annotation.dart';

/// This allows the `Reactive` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'reactive.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class Reactive {
  Reactive(
    this.rID,
    this.fTime,
    this.bTime,
    this.lTime,
    this.rTime,
    this.mTime,
    this.tID,
  );

  @JsonKey(required: true)
  int rID;

  @JsonKey(required: true)
  double fTime;

  @JsonKey(required: true)
  double bTime;

  @JsonKey(required: true)
  double lTime;

  @JsonKey(required: true)
  double rTime;

  @JsonKey(required: true)
  double mTime;

  @JsonKey(required: true)
  int tID;

  /// A necessary factory constructor for creating a new Incident instance
  /// from a map. Pass the map to the generated `_$ReactiveFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Incident.
  factory Reactive.fromJson(Map<String, dynamic> json) =>
      _$ReactiveFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$ReactiveToJson`.
  Map<String, dynamic> toJson() => _$ReactiveToJson(this);
}
