import 'api_util.dart' as api;
import 'dart:convert';

/// get IMU data from the database
///
/// @param rId: id of the test
/// @param sId: id of the test
/// @param dId: id of the test
///
/// @return Json object with the IMU Data
Future getIMU(int? rID, int? sID, int? dID) async {
  String enpointString = "/mysql/getIMU?";
  if (rID != null) {
    enpointString += "rID=$rID";
    if (sID != null || dID != null) {
      enpointString += "&";
    }
  }
  if (sID != null) {
    enpointString += "sID=$sID";
    if (dID != null) {
      enpointString += "&";
    }
  }
  if (dID != null) {
    enpointString += "dID=$dID";
  }
  var results = await api.get(enpointString);
  return await jsonDecode(results);
}

/// insert IMU data to the database
///
/// @param imuInfo: imu info for the test
///
/// @return Json object with the patient infomation
Future insertIMU(Map imuInfo) async {
  var results = await api.post('/mysql/insertIMU', imuInfo);
  return await jsonDecode(results);
}
