import 'package:json_annotation/json_annotation.dart';

/// This allows the `Reactive` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'static.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class Static {
  Static(
    this.sID,
    this.tlSolidML,
    this.tlFoamML,
    this.slSolidML,
    this.slFoamML,
    this.tandSolidML,
    this.tandFoamML,
    this.tID,
  );

  @JsonKey(required: true)
  int sID;

  @JsonKey(required: true)
  double tlSolidML;

  @JsonKey(required: true)
  double tlFoamML;

  @JsonKey(required: true)
  double slSolidML;

  @JsonKey(required: true)
  double slFoamML;

  @JsonKey(required: true)
  double tandSolidML;

  @JsonKey(required: true)
  double tandFoamML;

  @JsonKey(required: true)
  int tID;

  /// A necessary factory constructor for creating a new Static instance
  /// from a map. Pass the map to the generated `_$StaticFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Incident.
  factory Static.fromJson(Map<String, dynamic> json) => _$StaticFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$StaticToJson`.
  Map<String, dynamic> toJson() => _$StaticToJson(this);
}
