import 'api_util.dart';
import 'dart:convert';

Future getAll() async {
  return await jsonDecode(
      '[{"pID": 1, "firstName": "John", "lastName": "Doe"}, {"pID": 2, "firstName": "Jane", "lastName": "Smith"}, {"pID": 3, "firstName": "Austin", "lastName": "Hill"}]');
}

Future get(int patientId) async {
  return await jsonDecode(
      '{"pID": 1, "firstName": "John", "lastName": "Doe", "dOB": "1998-04-18", "height": 70, "weight": 215, "sport": "football", "gender": "M", "thirdPartyID": "62936", "incidents": [{"iID": 1, "iName": "Concussion", "iDate": "2023-09-20"}, {"iID": 2, "iName": "Knee Fracture", "iDate": "2023-12-20"}]}');
}

Future create(Object patientInfo) async {
  return await jsonDecode(
      '{"pID": 1, "firstName": "John", "lastName": "Doe", "dOB": "1998-04-18", "height": 70, "weight": 215, "sport": "football", "gender": "M", "thirdPartyID": "62936"}');
}

Future update(Object patientInfo) async {
  return await jsonDecode(
      '{"pID": 1, "firstName": "John", "lastName": "Doe", "dOB": "1998-04-18", "height": 70, "weight": 215, "sport": "football", "gender": "M", "thirdPartyID": "62936"}');
}

Future delete(int patientId) async {
  // was the deletion successful
  return true;
}
