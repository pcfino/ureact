import 'package:json_annotation/json_annotation.dart';
import 'package:capstone_project/models/incident.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'patient_export.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class PatientExport {
  PatientExport(this.thirdPartyID, this.incidents);

  @JsonKey(required: true)
  String? thirdPartyID;

  List<Incident>? incidents;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory PatientExport.fromJson(Map<String, dynamic> json) =>
      _$PatientExportFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$PatientExportToJson(this);
}
