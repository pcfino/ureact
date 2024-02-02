import 'api_util.dart' as api;
import 'dart:convert';

/// Makes request to get a test and relevent information
///
/// @param testId: info needed to get a test.
///
/// @return Json object with the test information
Future get(int testId) async {
  var results = await api.get('/mysql/getTest?ID=$testId');
  return await jsonDecode(results);
}

/// Makes request to create a test
///
/// @param testInfo: info needed to create a test.
/// The object should take the folowing form:
/// {tName: String, tDate: String form YYYY-MM-DD, tNotes: String, baseline: int, iID: int}
///
/// @return Json object with the created test
Future create(Map testInfo) async {
  var results = await api.post('/mysql/createTest', testInfo);
  return await jsonDecode(results);
}

/// Makes request to create a reactive test
///
/// @param testInfo: info needed to create a reactive test.
/// The object should take the folowing form:
/// {tID: int, fTime: float, bTime: float, lTime: float, rTime: float, mTime: float}
///
/// @return Json object with the created reactive test
Future createReactive(Map testInfo) async {
  var results = await api.post('/mysql/createReactiveTest', testInfo);
  return await jsonDecode(results);
}

/// Makes request for analysis on raw accelerometer and gyroscope
/// data to determine the time to stability
///
/// @param sensorData: Object containing all needed sensor data.
/// The object should take the folowing form:
/// {dataAcc: [float], dataRot: [float], timeStamps: [int], fs: int}
///
/// @return Json object with the time to stibility
Future runReactiveTestScript(Map sensorData) async {
  try {
    var results = await api.post('/timeToStability', sensorData);
    return await jsonDecode(results);
  } catch (err) {
    return {"TTS": 0.0};
  }
}
