import 'api_util.dart';
import 'dart:convert';

Future get(int incidentId) async {
  return await jsonDecode(
      '{"iID": 1, "iName": "Concussion", "iDate": "2023-09-20", "iNotes": "this person suffered a head injury", "tests": [{"tID": 1, "tDate": "2023-09-20", "tName": "Day of"}, {"tID": 2, "tDate": "2023-09-21", "tName": "Day after"}]}');
}

Future create(Object incidentInfo) async {
  return await jsonDecode(
      '{"iID": 1, "iName": "Concussion", "iDate": "2023-09-20", "iNotes": "this person suffered a head injury", "pID": 1}');
}

Future update(int incidentId, Object incidentInfo) async {
  return await jsonDecode(
      '{"iID": 1, "iName": "Concussion", "iDate": "2023-09-20", "iNotes": "this person suffered a head injury", "pID": 1}');
}

Future delete(int incidentId) async {
  // was the deletion successful
  return true;
}
