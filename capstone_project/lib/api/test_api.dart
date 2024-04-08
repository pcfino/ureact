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

/// Makes request to delete a Test and relevent information
///
/// @param testID: info needed to delete a test.
///
/// @return boolean if deletion was successful
Future delete(int testID) async {
  var results = await api.delete('/mysql/deleteTest', {'tID': testID});
  var decodedResults = jsonDecode(results);
  return decodedResults['Status'];
}

/// Makes request to update a Test and relevent information
///
/// @param testID: id needed to update a test.
/// @param testInfo: info to update in the test
///
/// @return updated test info
Future update(int testID, Map testInfo) async {
  var results = await api.put('/mysql/updateTest', testInfo);
  return await jsonDecode(results);
}

/// SWITCH TO THIS WHEN READY
/// NEW AND UPDATED GET TEST METHOD THAT RETURNS ALL INFORMATION FROM ALL 3 TESTS
/// Makes request to get test and relevent information
///
/// @param testId: info needed to get a test.
///
/// @return Json object with the test information (if any test is empty, returns like this: reactive{})
/// [
///    {
///        "tID": 51,
///        "tName": "6 Month Followup",
///        "tDate": "2025-07-15",
///        "tNotes": "",
///        "iID": 42,
///        "reactiveTest": {
///            "rID": 56,
///            "fTime": 0.42,
///            "bTime": 0.38,
///            "lTime": 0.45,
///            "rTime": 0.35,
///            "mTime": 0.4,
///            "tID": 51
///        },
///        "dynamicTest": {
///            "dID": 2,
///            "t1Duration": 1.45,
///            "t1TurnSpeed": 1.27,
///            "t1MLSway": 1.95,
///            "t2Duration": 0.54,
///            "t2TurnSpeed": 0.28,
///            "t2MLSway": 0.18,
///            "t3Duration": 0.98,
///            "t3TurnSpeed": 1.99,
///            "t3MLSway": 2.88,
///            "dMax": 3.9,
///            "dMin": 2.9,
///            "dMean": 1.7,
///            "dMedian": 1.5,
///            "tsMax": 1.7,
///            "tsMin": 0.6,
///            "tsMean": 0.68,
///            "tsMedian": 2.25,
///            "mlMax": 1.25,
///            "mlMin": 1.68,
///            "mlMean": 2.34,
///            "mlMedian": 1.74,
///            "tID": 51
///        },
///        "staticTest": {
///            "sID": 4,
///            "tlSolidML": 1.96,
///            "tlFoamML": 1.72,
///            "slSolidML": 0.98,
///            "slFoamML": 0.75,
///            "tandSolidML": 0.64,
///            "tandFoamML": 0.15,
///            "tID": 51
///        }
///     }
/// ]
///
Future getAllTests(int testId) async {
  var results = await api.get('/mysql/getAllTests?ID=$testId');
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

/// Makes request to create a dynamic test
///
/// @param testInfo: info needed to create a dynamic test.
/// The object should take the folowing form:
/// {tID: int, t1Duration: float, t1TurnSpeed: float, t1MLSway: float,
///            t2Duration: float, t2TurnSpeed: float, t2MLSway: float,
///            t3Duration: float, t3TurnSpeed: float, t3MLSway: float,
///            dMax: float, dMin: float, dMean: float, dMedian: float,
///            tsMax: float, tsMin: float, tsMean: float, tsMedian: float,
///            mlMax: float, mlMin: float, mlMean: float, mlMedian: float }
///
/// @return Json object with the created dynamic test
Future createDynamic(Map testInfo) async {
  var results = await api.post('/mysql/createDynamicTest', testInfo);
  // return should look like:
  // {"dID":2,"t1Duration":1.45,"t1TurnSpeed":1.27,"t1MLSway":1.95,"t2Duration":0.54,"t2TurnSpeed":0.28,"t2MLSway":0.18,"t3Duration":0.98,"t3TurnSpeed":1.99,"t3MLSway":2.88,"dMax":3.9,"dMin":2.9,"dMean":1.7,"dMedian":1.5,"tsMax":1.7,"tsMin":0.6,"tsMean":0.68,"tsMedian":2.25,"mlMax":1.25,"mlMin":1.68,"mlMean":2.34,"mlMedian":1.74,"tID":51}
  return await jsonDecode(results);
}

/// Makes request to create a static test
///
/// @param testInfo: info needed to create a static test.
/// The object should take the folowing form:
/// {tID: int, tlSolidML: float, tlFoamML: float, slSolidML: float, slFoamML: float, tandSolidML: float, tandFoamML: float}
///
/// @return Json object with the created static test
Future createStatic(Map testInfo) async {
  var results = await api.post('/mysql/createStaticTest', testInfo);
  // return should look like:
  // {"sID":1,"tlSolidML":1.96,"tlFoamML":1.72,"slSolidML":0.98,"slFoamML":0.75,"tandSolidML":0.64,"tandFoamML":0.15,"tID":42}
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

/// Makes request for analysis on raw accelerometer and gyroscope
/// data to determine the sway parameters
///
/// @param sensorData: Object containing all needed sensor data.
/// The object should take the folowing form:
/// {dataAcc: [float], dataRot: [float], timeStamps: [int], fs: int}
///
/// @return Json object with the sway parameteres
Future runSwayTestScript(Map sensorData) async {
  try {
    var results = await api.post('/sway', sensorData);
    return await jsonDecode(results);
  } catch (err) {
    return {"rmsMl": 0.0, "rmsAp": 0.0, "rmsV": 0.0};
  }
}

/// Makes request for analysis on raw accelerometer and gyroscope
/// data to determine the sway parameter
///
/// @param sensorData: Object containing all needed sensor data.
/// The object should take the folowing form:
/// {dataAcc: [float], dataRot: [float], timeStamps: [int], fs: int}
///
/// @return Json object with the sway parameteres
Future runTandemGaitTestScript(Map sensorData) async {
  try {
    var results = await api.post('/tandemGait', sensorData);
    return await jsonDecode(results);
  } catch (err) {
    return {
      "rmsMlGoing": 0.0,
      "rmsApGoing": 0.0,
      "rmsMlReturn": 0.0,
      "rmsApReturn": 0.0,
      "duration": 0.0,
      "turningSpeed": 0.0
    };
  }
}

/// Makes request to get a baseline and the test information from that baseline
///
/// @param patientId: patientID need to find basline
///
/// @return Json object with the incident information
Future getBaseline(int testId) async {
  var results = await api.get('/mysql/getBaseline?ID=$testId');
  return await jsonDecode(results);
}
