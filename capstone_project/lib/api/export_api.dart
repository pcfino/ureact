import 'api_util.dart' as api;
import 'dart:convert';

/// Fetches all the information needed to export a single patient's data
///
/// @param patientId: id of the patient
///
/// @return Json object with the patient infomation
Future get(int patientId) async {
  // var results =
  //     '{"thirdPartyID": "1234567","incidents": [{"iName": "Concussion","iDate": "2024-01-14","iNotes": "incident notes","tests": [{"tDate": "2024-02-08","reactive": {"mTime": "1.00"}},{"tDate": "2024-02-07","reactive": {"mTime": "1.50"}}]},{"iName": "Knee Injury", "iDate": "2020-02-20", "iNotes": "more notes", "tests": []}, {"iName": "Baseline", "iDate": "1900-04-01", "iNotes": "extra notes", "tests": [{"tDate": "1900-04-01", "reactive": {"mTime": "0.65"}}]}]}';
  var results = await api.get('/mysql/exportSinglePatient?ID=$patientId');
  return jsonDecode(results);
}
