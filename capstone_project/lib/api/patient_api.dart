import 'api_util.dart' as api;
import 'dart:convert';

/// Makes request to get all patients
///
/// @return Json object with the patients info
Future getAll(int orgID) async {
  var results = await api.get('/mysql/getAllPatients?ID=$orgID');
  return jsonDecode(results);
}

/// Makes request to get a patient and relevent information
///
/// @param patientId: info needed to get a patient.
///
/// @return Json object with the patient information
Future get(int patientId) async {
  var results = await api.get('/mysql/getOnePatient?ID=$patientId');
  return await jsonDecode(results);
}

/// Makes request to create a patient
///
/// @param patientInfo: info needed to create a patient.
/// The object should take the folowing form:
/// {firstName: String, lastName: String, dOB: String form YYYY-MM-DD, height: int, weight: int, sport: String, gender: String, thirdPartyID: String}
///
/// @return Json object with the created patient
Future create(Map patientInfo) async {
  var results = await api.post('/mysql/createNewPatient', patientInfo);
  return await jsonDecode(results);
}

/// Makes request to update a patient
///
/// @param patientId: id of the patient to update
/// @param patientInfo: info needed to update a patient.
/// The object should take the folowing form:
/// {firstName: String, lastName: String, dOB: String form YYYY-MM-DD, height: int, weight: int, sport: String, gender: String, thirdPartyID: String}
///
/// @return Json object with the created patient
Future update(int patientId, Map patientInfo) async {
  patientInfo['pID'] = patientId;
  var results = await api.put('/mysql/updatePatient', patientInfo);
  return await jsonDecode(results);
}

/// Makes request to delete a patient and relevent information
///
/// @param patientId: info needed to delete a patient.
///
/// @return boolean if deletion was successful
Future delete(int patientId) async {
  var results = await api.delete('/mysql/deletePatient', {'pID': patientId});
  var decodedResults = jsonDecode(results);
  return decodedResults['Status'];
}
