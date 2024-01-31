// import 'api_util.dart';
import 'dart:convert';

/// Makes request to get all patients
///
/// @return Json object with the patients info
Future getAll() async {
  return await jsonDecode(
      '[{"pID": 1, "firstName": "John", "lastName": "Doe"}, {"pID": 2, "firstName": "Jane", "lastName": "Smith"}, {"pID": 3, "firstName": "Austin", "lastName": "Hill"}]');
}

/// Makes request to get a patient and relevent information
///
/// @param patientId: info needed to get a patient.
///
/// @return Json object with the patient information
Future get(int patientId) async {
  return await jsonDecode(
      '{"pID": 1, "firstName": "John", "lastName": "Doe", "dOB": "1998-04-18", "height": 70, "weight": 215, "sport": "football", "gender": "M", "thirdPartyID": "62936", "patients": [{"iID": 1, "iName": "Concussion", "iDate": "2023-09-20"}, {"iID": 2, "iName": "Knee Fracture", "iDate": "2023-12-20"}]}');
}

/// Makes request to create a patient
///
/// @param patientInfo: info needed to create a patient.
/// The object should take the folowing form:
/// {firstName: String, lastName: String, dOB: String form YYYY-MM-DD, height: int, weight: int, sport: String, gender: String, thirdPartyID: String}
///
/// @return Json object with the created patient
Future create(Object patientInfo) async {
  return await jsonDecode(
      '{"pID": 1, "firstName": "John", "lastName": "Doe", "dOB": "1998-04-18", "height": 70, "weight": 215, "sport": "football", "gender": "M", "thirdPartyID": "62936"}');
}

/// Makes request to update a patient
///
/// @param patientId: id of the patient to update
/// @param patientInfo: info needed to update a patient.
/// The object should take the folowing form:
/// {firstName: String, lastName: String, dOB: String form YYYY-MM-DD, height: int, weight: int, sport: String, gender: String, thirdPartyID: String}
///
/// @return Json object with the created patient
Future update(int patientId, Object patientInfo) async {
  return await jsonDecode(
      '{"pID": 1, "firstName": "John", "lastName": "Doe", "dOB": "1998-04-18", "height": 70, "weight": 215, "sport": "football", "gender": "M", "thirdPartyID": "62936"}');
}

/// Makes request to delete a patient and relevent information
///
/// @param patientId: info needed to delete a patient.
///
/// @return boolean if deletion was successful
Future delete(int patientId) async {
  // was the deletion successful
  return true;
}
