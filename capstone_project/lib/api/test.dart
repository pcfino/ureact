import 'api_util.dart';
import 'dart:convert';

/// Makes request to get a test and relevent information
///
/// @param testId: info needed to get a test.
///
/// @return Json object with the test information
Future get(int testId) async {
  return await jsonDecode(
      '{"tID": 1, "tName": "Day of", "tDate": "2023-09-20", "tNotes": "this is some notes about the test", "baseline": 0, "iID": 1, "dynamic": {}, "static": {}, "reactive": {"rID": 1, "fTime": 1.234, "bTime": 0.873, "lTime": 0.876, "rTime": 0.945, "mTime": 0.912, "tID": 1}}');
}

/// Makes request to create a test
///
/// @param testInfo: info needed to create a test.
/// The object should take the folowing form:
/// {tName: String, tDate: String form YYYY-MM-DD, tNotes: String, baseline: int, iID: int}
///
/// @return Json object with the created test
Future create(Object testInfo) async {
  return await jsonDecode(
      '{"tID": 1, "tName": "Day of", "tDate": "2023-09-20", "tNotes": "this is some notes about the test", "baseline": 0, "iID": 1, "dynamic": {}, "static": {}, "reactive": {}}');
}

/// Makes request to create a reactive test
///
/// @param testInfo: info needed to create a reactive test.
/// The object should take the folowing form:
/// {tID: int, fTime: float, bTime: float, lTime: float, rTime: float, mTime: float}
///
/// @return Json object with the created reactive test
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
