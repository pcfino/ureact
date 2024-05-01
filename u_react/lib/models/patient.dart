import 'package:json_annotation/json_annotation.dart';
import 'package:u_react/models/incident.dart';

/// This allows the `Patient` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'patient.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class Patient {
  Patient(this.pID, this.firstName, this.lastName, this.dOB, this.height,
      this.weight, this.sport, this.gender, this.thirdPartyID, this.incidents);

  @JsonKey(required: true)
  int pID;

  @JsonKey(required: true)
  String firstName;

  @JsonKey(required: true)
  String lastName;

  String? dOB;
  int? height;
  int? weight;
  String? sport;
  String? gender;
  String? thirdPartyID;

  List<Incident>? incidents;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$PatientFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Patient.fromJson(Map<String, dynamic> json) =>
      _$PatientFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$PatientToJson`.
  Map<String, dynamic> toJson() => _$PatientToJson(this);
}
