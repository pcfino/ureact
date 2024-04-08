import 'api_util.dart' as api;
import 'dart:convert';

/// Fetches all the information needed to export a single patient's data
///
/// @param patientId: id of the patient
///
/// @return Json object with the patient infomation
Future get(int patientId) async {
  var results = await api.get('/mysql/exportSinglePatient?ID=$patientId');
  return await jsonDecode(results);
}

/// Fetches all the information needed to export a single Incident worth of patient's data
///
/// @param patientId: id of the patient
/// @param incidentID: id of the incident
///
/// @return Json object with the patient infomation
Future exportIncident(int patientId, int incidentID) async {
  var results = await api
      .get('/mysql/exportSingleIncident?pID=$patientId&iID=$incidentID');
  return await jsonDecode(results);
}

/// Fetches all the information needed to export a single Test worth of patient's data
///
/// @param patientId: id of the patient
/// @param testId: id of the incident
///
/// @return Json object with the patient infomation
Future exportTest(int patientId, int testID) async {
  var results =
      await api.get('/mysql/exportSinglePatient?ID=$patientId&tID=$testID');
  return await jsonDecode(results);
}
