import 'api_util.dart';
import 'dart:convert';

Future get(int testId) async {
  return await jsonDecode(
      '{"tID": 1, "tName": "Day of", "tDate": "2023-09-20", "tNotes": "this is some notes about the test", "baseline": 0, "iID": 1, "dynamic": {}, "static": {}, "reactive": {"rID": 1, "fTime": 1.234, "bTime": 0.873, "lTime": 0.876, "rTime": 0.945, "mTime": 0.912, "tID": 1}}');
}

Future create(Object testInfo) async {
  return await jsonDecode(
      '{"tID": 1, "tName": "Day of", "tDate": "2023-09-20", "tNotes": "this is some notes about the test", "baseline": 0, "iID": 1, "dynamic": {}, "static": {}, "reactive": {}}');
}

/// Makes request for analysis on raw accelerometer and gyroscope
/// data to determine the time to stability
///
/// @param sensorData: Object containing all needed sensor data.
/// The object should take the folowing form:
/// {dataAcc: [float], dataRot: [float], timeStamps: [int], fs: int}
///
/// @return Json object with the time to stibility
Future createReactive(Object testInfo) async {
  return await jsonDecode(
      '{"rID": 1, "fTime": 1.234, "bTime": 0.873, "lTime": 0.876, "rTime": 0.945, "mTime": 0.912, "tID": 1}');
}

/// Makes request for analysis on raw accelerometer and gyroscope
/// data to determine the time to stability
///
/// @param sensorData: Object containing all needed sensor data.
/// The object should take the folowing form:
/// {dataAcc: [float], dataRot: [float], timeStamps: [int], fs: int}
///
/// @return Json object with the time to stibility
Future runReactiveTestScript(Object sensorData) async {
  return await jsonDecode('{"TTS": 0.987}');
}
