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
