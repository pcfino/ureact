import 'api_util.dart';
import 'dart:convert';

/// Makes request to get a incident and relevent information
///
/// @param incidentId: info needed to get a incident.
///
/// @return Json object with the incident information
Future get(int incidentId) async {
  return await jsonDecode(
      '{"iID": 1, "iName": "Concussion", "iDate": "2023-09-20", "iNotes": "this person suffered a head injury"}');
  // '{"iID": 1, "iName": "Concussion", "iDate": "2023-09-20", "iNotes": "this person suffered a head injury", "tests": [{"tID": 1, "tDate": "2023-09-20", "tName": "Day of"}, {"tID": 2, "tDate": "2023-09-21", "tName": "Day after"}]}');
}

/// Makes request to create a incident
///
/// @param incidentInfo: info needed to create a incident.
/// The object should take the folowing form:
/// {iName: String, iDate: String form YYYY-MM-DD, iNotes: String, pID: int}
///
/// @return Json object with the created incident
Future create(Object incidentInfo) async {
  return await jsonDecode(
      '{"iID": 1, "iName": "Concussion", "iDate": "2023-09-20", "iNotes": "this person suffered a head injury", "pID": 1}');
}

/// Makes request to update a incident
///
/// @param incidentId: id of the incident to update
/// @param incidentInfo: info needed to update a incident.
/// The object should take the folowing form:
/// {iName: String, iDate: String form YYYY-MM-DD, iNotes: String, pID: int}
///
/// @return Json object with the created incident
Future update(int incidentId, Object incidentInfo) async {
  return await jsonDecode(
      '{"iID": 1, "iName": "Concussion", "iDate": "2023-09-20", "iNotes": "this person suffered a head injury", "pID": 1}');
}

/// Makes request to delete a incident and relevent information
///
/// @param incidentId: info needed to delete a incident.
///
/// @return boolean if deletion was successful
Future delete(int incidentId) async {
  return true;
}
