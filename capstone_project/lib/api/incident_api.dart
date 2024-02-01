import 'api_util.dart' as api;
import 'dart:convert';

/// Makes request to get a incident and relevent information
///
/// @param incidentId: info needed to get a incident.
///
/// @return Json object with the incident information
Future get(int incidentId) async {
  var results = await api.get('/mysql/getIncident?ID=$incidentId');
  return await jsonDecode(results);
}

/// Makes request to create a incident
///
/// @param incidentInfo: info needed to create a incident.
/// The object should take the folowing form:
/// {iName: String, iDate: String form YYYY-MM-DD, iNotes: String, pID: int}
///
/// @return Json object with the created incident
Future create(Map incidentInfo) async {
  var results = await api.post('/mysql/createIncident', incidentInfo);
  return await jsonDecode(results);
}

/// Makes request to update a incident
///
/// @param incidentId: id of the incident to update
/// @param incidentInfo: info needed to update a incident.
/// The object should take the folowing form:
/// {iName: String, iDate: String form YYYY-MM-DD, iNotes: String, pID: int}
///
/// @return Json object with the created incident
Future update(int incidentId, Map incidentInfo) async {
  incidentInfo['iID'] = incidentId;
  var results = await api.put('/mysql/updateIncident', incidentInfo);
  return await jsonDecode(results);
}

/// Makes request to delete a incident and relevent information
///
/// @param incidentId: info needed to delete a incident.
///
/// @return boolean if deletion was successful
Future delete(int incidentId) async {
  var results = await api.delete('/mysql/deleteIncident', {'iID': incidentId});
  var decodedResults = jsonDecode(results);
  return decodedResults['Status'];
}
