import 'package:json_annotation/json_annotation.dart';
import 'package:u_react/models/test.dart';

/// This allows the `Incident` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'incident.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class Incident {
  Incident(this.iID, this.iName, this.iDate, this.iNotes, this.pID, this.tests);

  @JsonKey(required: true)
  int iID;

  @JsonKey(required: true)
  String iName;

  @JsonKey(required: true)
  String iDate;

  @JsonKey(required: true)
  int pID;

  String? iNotes;
  List<Test>? tests;

  /// A necessary factory constructor for creating a new Incident instance
  /// from a map. Pass the map to the generated `_$IncidentFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Incident.
  factory Incident.fromJson(Map<String, dynamic> json) =>
      _$IncidentFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$IncidentToJson`.
  Map<String, dynamic> toJson() => _$IncidentToJson(this);
}
