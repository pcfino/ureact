import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:u_react/api/export_api.dart' as export_api;
import 'package:u_react/api/imu_api.dart' as imu_api;
import 'package:u_react/models/dynamic.dart';

/* ------------------------------------- Headers ------------------------------------- */

List<dynamic> csvHeader = [
  '3rd Party ID',
  'Incident',
  'Incident Date/Time',
  'Condition',
  'Reactive MTime',
  'fTime',
  'bTime',
  'lTime',
  'rTime',
  'Static TL Solid ML',
  'Static TL Foam ML',
  'Dynamic T1 Duration',
  'Dynamic T1 TurnSpeed',
  'Dynamic T1 ML Sway',
  'Dynamic T2 Duration',
  'Dynamic T2 TurnSpeed',
  'Dynamic T2 ML Sway',
  'Dynamic T3 Duration',
  'Dynamic T3 TurnSpeed',
  'Dynamic T3 ML Sway',
  'dMax',
  'dMin',
  'dMean',
  'dMedian',
  'tsMax',
  'tsMin',
  'tsMean',
  'tsMedian',
  'mlMax',
  'mlMin',
  'mlMean',
  'mlMedian',
];

/* ------------------------------------- API Calls ------------------------------------- */

Future<dynamic> getPatientData(int pID) async {
  try {
    dynamic jsonExport = await export_api.exportPatient(pID);
    return jsonExport[0];
  } catch (e) {
    print("Error fetching export data: $e");
  }
}

Future<dynamic> getIncidentData(int pID, int iID) async {
  try {
    dynamic jsonExport = await export_api.exportIncident(pID, iID);
    return jsonExport[0];
  } catch (e) {
    print("Error fetching export data: $e");
  }
}

Future<dynamic> getTestData(int pID, int tID) async {
  try {
    dynamic jsonExport = await export_api.exportTest(pID, tID);
    return jsonExport[0];
  } catch (e) {
    print("Error fetching export data: $e");
  }
}

Future<dynamic> getIMUData(int? rID, int? sID, int? dID) async {
  try {
    dynamic jsonExport = await imu_api.getIMU(rID, sID, dID);
    return jsonExport[0];
  } catch (e) {
    print("Error fetching export data: $e");
  }
}

/* ------------------------------------- Export Methods ------------------------------------- */

void exportPatient(int pID) async {
  String fileName = "";
  Map<String, dynamic> json = await getPatientData(pID);

  if (json.containsKey('thirdPartyID')) {
    fileName = "patient${json['thirdPartyID']}";
  }

  exportData(fileName, json, true);
}

void exportIncident(int pID, int iID) async {
  String fileName = "";
  Map<String, dynamic> json = await getIncidentData(pID, iID);

  if (json.containsKey('thirdPartyID')) {
    if (json.containsKey('iName') && json.containsKey('iDate')) {
      fileName =
          "patient${json['thirdPartyID']}_${json['iName']}_${json['iDate']}";
    }
  }

  exportData(fileName, json, false);
}

void exportTest(int pID, int tID) async {
  String fileName = "";
  Map<String, dynamic> json = await getTestData(pID, tID);

  if (json.containsKey('thirdPartyID')) {
    if (json.containsKey('iName') && json.containsKey('iDate')) {
      fileName =
          "patient${json['thirdPartyID']}_${json['iName']}_${json['iDate']}_tests";
    }
  }

  exportData(fileName, json, false);
}

void exportIMU(
    int? rID, int? sID, int? dID, String? thirdPartyID, String? tDate) async {
  String fileName = "";
  List<List<dynamic>> rows = [];
  // List<dynamic> leftDataAcc = [];
  // List<dynamic> rightDataAcc = [];
  // List<dynamic> forwardDataAcc = [];
  // List<dynamic> backwardDataAcc = [];
  // List<dynamic> tlSolidDataAcc = [];
  // List<dynamic> slSolidDataAcc = [];
  List<dynamic> dataAcc = [];

  // List<dynamic> leftDataRot = [];
  // List<dynamic> rightDataRot = [];
  // List<dynamic> forwardDataRot = [];
  // List<dynamic> backwardDataRot = [];
  // List<dynamic> tlSolidDataRot = [];
  // List<dynamic> slSolidDataRot = [];
  List<dynamic> dataRot = [];

  // List<dynamic> leftTimeStampData = [];
  // List<dynamic> rightTimeStampData = [];
  // List<dynamic> forwardTimeStampData = [];
  // List<dynamic> backwardTimeStampData = [];
  // List<dynamic> tlSolidTimeStampData = [];
  // List<dynamic> slSolidTimeStampData = [];
  List<dynamic> timestampData = [];

  List<dynamic> imuHeader = [
    "test",
    "accelX",
    "accelY",
    "accelZ",
    "rotX",
    "rotY",
    "rotZ",
    "timestamp"
  ];
  rows.add(imuHeader);

  Map<String, dynamic> json = await getIMUData(rID, sID, dID);
  print(rID.toString() + " " + sID.toString() + " " + dID.toString());
  print(json);

  if (json.containsKey('imuID')) {
    if (json["imuData"]["left"]["dataAcc"] != null &&
        json["imuData"]["left"]["dataRot"] != null) {
      // leftDataAcc = json["imuData"]["left"]["dataAcc"];
      dataAcc = json["imuData"]["left"]["dataAcc"];
      // leftDataRot = json["imuData"]["left"]["dataRot"];
      dataRot = json["imuData"]["left"]["dataRot"];

      // leftTimeStampData = json["imuData"]["left"]["timeStamps"];
      timestampData = json["imuData"]["left"]["timeStamps"];

      for (int i = 0; i < dataRot[0].length; i++) {
        List<dynamic> row = [
          "reactive-left",
          dataAcc[0][i],
          dataAcc[1][i],
          dataAcc[2][i],
          dataRot[0][i],
          dataRot[1][i],
          dataRot[2][i],
          timestampData[i],
        ];
        rows.add(row);
      }
      print("finished left");
    }
    if (json["imuData"]["right"]["dataAcc"] != null &&
        json["imuData"]["right"]["dataRot"] != null) {
      dataAcc = json["imuData"]["right"]["dataAcc"];
      dataRot = json["imuData"]["right"]["dataRot"];
      timestampData = json["imuData"]["right"]["timeStamps"];

      for (int i = 0; i < dataRot[0].length; i++) {
        List<dynamic> row = [
          "reactive-right",
          dataAcc[0][i],
          dataAcc[1][i],
          dataAcc[2][i],
          dataRot[0][i],
          dataRot[1][i],
          dataRot[2][i],
          timestampData[i],
        ];
        rows.add(row);
      }
      print("finished right");
    }
    if (json["imuData"]['forward']["dataAcc"] != null &&
        json["imuData"]['forward']["dataRot"] != null) {
      dataAcc = json["imuData"]["forward"]["dataAcc"];
      dataRot = json["imuData"]["forward"]["dataRot"];
      timestampData = json["imuData"]["forward"]["timeStamps"];

      for (int i = 0; i < dataRot[0].length; i++) {
        List<dynamic> row = [
          "reactive-forward",
          dataAcc[0][i],
          dataAcc[1][i],
          dataAcc[2][i],
          dataRot[0][i],
          dataRot[1][i],
          dataRot[2][i],
          timestampData[i],
        ];
        rows.add(row);
      }
      print("finished forward");
    }
    if (json["imuData"]['backward']["dataAcc"] != null &&
        json["imuData"]['backward']["dataRot"] != null) {
      dataAcc = json["imuData"]["backward"]["dataAcc"];
      dataRot = json["imuData"]["backward"]["dataRot"];
      timestampData = json["imuData"]["backward"]["timeStamps"];

      for (int i = 0; i < dataRot[0].length; i++) {
        List<dynamic> row = [
          "reactive-backward",
          dataAcc[0][i],
          dataAcc[1][i],
          dataAcc[2][i],
          dataRot[0][i],
          dataRot[1][i],
          dataRot[2][i],
          timestampData[i],
        ];
        rows.add(row);
      }
      print("finished backward");
    }
    print(json["imuData"].keys);
    if (json["imuData"]["tlSolid"]["dataAcc"] != null &&
        json["imuData"]["tlSolid"]["dataRot"] != null) {
      dataAcc = json["imuData"]["tlSolid"]["dataAcc"];
      dataRot = json["imuData"]["tlSolid"]["dataRot"];
      timestampData = json["imuData"]["tlSolid"]["timeStamps"];

      for (int i = 0; i < dataRot[0].length; i++) {
        List<dynamic> row = [
          "static-tlSolid",
          dataAcc[0][i],
          dataAcc[1][i],
          dataAcc[2][i],
          dataRot[0][i],
          dataRot[1][i],
          dataRot[2][i],
          timestampData[i],
        ];
        rows.add(row);
      }
      print("finished tlSolid");
    }
    if (json["imuData"]["slSolid"]["dataAcc"] != null &&
        json["imuData"]["slSolid"]["dataRot"] != null) {
      dataAcc = json["imuData"]["slSolid"]["dataAcc"];
      dataRot = json["imuData"]["slSolid"]["dataRot"];
      timestampData = json["imuData"]["slSolid"]["timeStamps"];

      for (int i = 0; i < dataRot[0].length; i++) {
        List<dynamic> row = [
          "static-slSolid",
          dataAcc[0][i],
          dataAcc[1][i],
          dataAcc[2][i],
          dataRot[0][i],
          dataRot[1][i],
          dataRot[2][i],
          timestampData[i],
        ];
        rows.add(row);
      }
      print("finished slSolid");
    }
    if (json["imuData"]["tandSolid"]["dataAcc"] != null &&
        json["imuData"]["tandSolid"]["dataRot"] != null) {
      dataAcc = json["imuData"]["tandSolid"]["dataAcc"];
      dataRot = json["imuData"]["tandSolid"]["dataRot"];
      timestampData = json["imuData"]["tandSolid"]["timeStamps"];

      for (int i = 0; i < dataRot[0].length; i++) {
        List<dynamic> row = [
          "static-tandSolid",
          dataAcc[0][i],
          dataAcc[1][i],
          dataAcc[2][i],
          dataRot[0][i],
          dataRot[1][i],
          dataRot[2][i],
          timestampData[i],
        ];
        rows.add(row);
      }
      print("finished tandSOlid");
    }
    if (json["imuData"]["tlFoam"]["dataAcc"] != null &&
        json["imuData"]["tlFoam"]["dataRot"] != null) {
      dataAcc = json["imuData"]["tlFoam"]["dataAcc"];
      dataRot = json["imuData"]["tlFoam"]["dataRot"];
      timestampData = json["imuData"]["tlFoam"]["timeStamps"];

      for (int i = 0; i < dataRot[0].length; i++) {
        List<dynamic> row = [
          "static-tlFoam",
          dataAcc[0][i],
          dataAcc[1][i],
          dataAcc[2][i],
          dataRot[0][i],
          dataRot[1][i],
          dataRot[2][i],
          timestampData[i],
        ];
        rows.add(row);
      }
      print("finished tlFoam");
    }
    if (json["imuData"]["slFoam"]["dataAcc"] != null &&
        json["imuData"]["slFoam"]["dataRot"] != null) {
      dataAcc = json["imuData"]["slFoam"]["dataAcc"];
      dataRot = json["imuData"]["slFoam"]["dataRot"];
      timestampData = json["imuData"]["slFoam"]["timeStamps"];

      for (int i = 0; i < dataRot[0].length; i++) {
        List<dynamic> row = [
          "static-slFoam",
          dataAcc[0][i],
          dataAcc[1][i],
          dataAcc[2][i],
          dataRot[0][i],
          dataRot[1][i],
          dataRot[2][i],
          timestampData[i],
        ];
        rows.add(row);
      }
      print("finished slFoam");
    }
    if (json["imuData"]["tandFoam"]["dataAcc"] != null &&
        json["imuData"]["tandFoam"]["dataRot"] != null) {
      dataAcc = json["imuData"]["tandFoam"]["dataAcc"];
      dataRot = json["imuData"]["tandFoam"]["dataRot"];
      timestampData = json["imuData"]["tandFoam"]["timeStamps"];

      for (int i = 0; i < dataRot[0].length; i++) {
        List<dynamic> row = [
          "static-tandFoam",
          dataAcc[0][i],
          dataAcc[1][i],
          dataAcc[2][i],
          dataRot[0][i],
          dataRot[1][i],
          dataRot[2][i],
          timestampData[i],
        ];
        rows.add(row);
      }
      print("finished tandFoam");
    }
    if (json["imuData"]["t1"]["dataAcc"] != null &&
        json["imuData"]["t1"]["dataRot"] != null) {
      dataAcc = json["imuData"]["t1"]["dataAcc"];
      dataRot = json["imuData"]["t1"]["dataRot"];
      timestampData = json["imuData"]["t1"]["timeStamps"];

      for (int i = 0; i < dataRot[0].length; i++) {
        List<dynamic> row = [
          "dynamic-t1",
          dataAcc[0][i],
          dataAcc[1][i],
          dataAcc[2][i],
          dataRot[0][i],
          dataRot[1][i],
          dataRot[2][i],
          timestampData[i],
        ];
        rows.add(row);
      }
      print("finished t1");
    }
    if (json["imuData"]["t2"]["dataAcc"] != null &&
        json["imuData"]["t2"]["dataRot"] != null) {
      dataAcc = json["imuData"]["t2"]["dataAcc"];
      dataRot = json["imuData"]["t2"]["dataRot"];
      timestampData = json["imuData"]["t2"]["timeStamps"];

      for (int i = 0; i < dataRot[0].length; i++) {
        List<dynamic> row = [
          "dynamic-t2",
          dataAcc[0][i],
          dataAcc[1][i],
          dataAcc[2][i],
          dataRot[0][i],
          dataRot[1][i],
          dataRot[2][i],
          timestampData[i],
        ];
        rows.add(row);
      }
      print("finished t2");
    }
    if (json["imuData"]["t3"]["dataAcc"] != null &&
        json["imuData"]["t3"]["dataRot"] != null) {
      dataAcc = json["imuData"]["t3"]["dataAcc"];
      dataRot = json["imuData"]["t3"]["dataRot"];
      timestampData = json["imuData"]["t3"]["timeStamps"];

      for (int i = 0; i < dataRot[0].length; i++) {
        List<dynamic> row = [
          "dynamic-t3",
          dataAcc[0][i],
          dataAcc[1][i],
          dataAcc[2][i],
          dataRot[0][i],
          dataRot[1][i],
          dataRot[2][i],
          timestampData[i],
        ];
        rows.add(row);
      }
      print("finished t3");
    }

    fileName = "imuData_patient${thirdPartyID}_test_${tDate}";
  }

  // Export patient data
  String csv = const ListToCsvConverter().convert(rows);
  String fileContent = csv;
  XFile csvFile = await createCSVFile(fileName, fileContent);
  await exportCSV(csvFile);
}

void exportData(
    String fileName, Map<String, dynamic> json, bool isPatient) async {
  List<List<dynamic>> rows = [];
  Map<int, Map<String, dynamic>> processedJson = {};

  if (isPatient) {
    processedJson = processPatientJSON(json);
  } else {
    processedJson = processIncidentTestJSON(json);
  }

  rows.add(csvHeader);
  // Reorder the row data so that it matches the csv column order
  processedJson.forEach((test, row) {
    List<dynamic> orderedRow = [];
    for (String header in csvHeader) {
      orderedRow.add(row[header]);
    }
    rows.add(orderedRow);
  });

  // Export patient data
  String csv = const ListToCsvConverter().convert(rows);
  String fileContent = csv;
  XFile csvFile = await createCSVFile(fileName, fileContent);
  await exportCSV(csvFile);
}

Map<int, Map<String, dynamic>> processPatientJSON(Map<String, dynamic> json) {
  List<List<dynamic>> rows = [];
  Map<int, Map<String, dynamic>> processedJson = {};
  if (json.containsKey('thirdPartyID')) {
    if (json.containsKey('incidents')) {
      List<dynamic> incidents = json['incidents'];

      // Iterate over incidents
      for (var incident in incidents) {
        if (incident.containsKey('tests')) {
          List<dynamic> tests = incident['tests'];

          // Iterate over tests
          for (var test in tests) {
            bool hasData = false;
            double? reactiveMTime;
            double? fTime;
            double? bTime;
            double? lTime;
            double? rTime;

            double? staticTLSolidML;
            double? staticTLFoamML;

            double? dynamicT1Duration;
            double? dynamicT1TurnSpeed;
            double? dynamicT1MLSway;

            double? dynamicT2Duration;
            double? dynamicT2TurnSpeed;
            double? dynamicT2MLSway;

            double? dynamicT3Duration;
            double? dynamicT3TurnSpeed;
            double? dynamicT3MLSway;

            double? dMax;
            double? dMin;
            double? dMean;
            double? dMedian;
            double? tsMax;
            double? tsMin;
            double? tsMean;
            double? tsMedian;
            double? mlMax;
            double? mlMin;
            double? mlMean;
            double? mlMedian;

            // Get reactive test data
            if (test.containsKey('reactive')) {
              if (test['reactive'].length != 0) {
                reactiveMTime = test['reactive']['mTime'];
                fTime = test['reactive']['fTime'];
                bTime = test['reactive']['bTime'];
                lTime = test['reactive']['lTime'];
                rTime = test['reactive']['rTime'];
                hasData = true;
              }
            }
            // Get static test data
            else if (test.containsKey('static')) {
              if (test['static'].length != 0) {
                staticTLSolidML = test['static']['tlSolidML'];
                staticTLFoamML = test['static']['tlFoamML'];
                hasData = true;
              }
            }
            // Get dynamic test data
            else if (test.containsKey('dynamic')) {
              if (test['dynamic'].length != 0) {
                dynamicT1Duration = test['dynamic']['t1Duration'];
                dynamicT1TurnSpeed = test['dynamic']['t1TurnSpeed'];
                dynamicT1MLSway = test['dynamic']['t1MLSway'];

                dynamicT2Duration = test['dynamic']['t2Duration'];
                dynamicT2TurnSpeed = test['dynamic']['t2TurnSpeed'];
                dynamicT2MLSway = test['dynamic']['t2MLSway'];

                dynamicT3Duration = test['dynamic']['t3Duration'];
                dynamicT3TurnSpeed = test['dynamic']['t3TurnSpeed'];
                dynamicT3MLSway = test['dynamic']['t3MLSway'];

                dMax = test['dynamic']['dMax'];
                dMin = test['dynamic']['dMin'];
                dMean = test['dynamic']['dMean'];
                dMedian = test['dynamic']['dMedian'];

                tsMax = test['dynamic']['tsMax'];
                tsMin = test['dynamic']['tsMin'];
                tsMean = test['dynamic']['tsMean'];
                tsMedian = test['dynamic']['tsMedian'];

                mlMax = test['dynamic']['mlMax'];
                mlMin = test['dynamic']['mlMin'];
                mlMean = test['dynamic']['mlMean'];
                mlMedian = test['dynamic']['mlMedian'];

                hasData = true;
              }
            }

            List<dynamic> row;

            if (hasData) {
              row = [
                json['thirdPartyID'],
                incident['iName'],
                incident['iDate'],
                incident['iNotes'],
                reactiveMTime,
                fTime,
                bTime,
                lTime,
                rTime,
                staticTLSolidML,
                staticTLFoamML,
                dynamicT1Duration,
                dynamicT1TurnSpeed,
                dynamicT1MLSway,
                dynamicT2Duration,
                dynamicT2TurnSpeed,
                dynamicT2MLSway,
                dynamicT3Duration,
                dynamicT3TurnSpeed,
                dynamicT3MLSway,
                dMax,
                dMin,
                dMean,
                dMedian,
                tsMax,
                tsMin,
                tsMean,
                tsMedian,
                mlMax,
                mlMin,
                mlMean,
                mlMedian,
              ];
              rows.add(row);

              // Condense csv rows to group related data
              if (processedJson.containsKey(test['tID'])) {
                int headerIndex = 0;
                for (var col in row) {
                  if (processedJson[test['tID']]?[csvHeader[headerIndex]] ==
                          null &&
                      col != null) {
                    processedJson[test['tID']]![csvHeader[headerIndex]] = col;
                  }
                  headerIndex++;
                }
              } else {
                int headerIndex = 0;
                for (var col in row) {
                  if (processedJson[test['tID']] == null) {
                    processedJson[test['tID']] = {};
                  }
                  processedJson[test['tID']]![csvHeader[headerIndex++]] = col;
                }
              }
            }
          }
        }
      }
    }
  }
  return processedJson;
}

Map<int, Map<String, dynamic>> processIncidentTestJSON(
    Map<String, dynamic> json) {
  List<List<dynamic>> rows = [];
  Map<int, Map<String, dynamic>> processedJson = {};
  if (json.containsKey('thirdPartyID')) {
    List<dynamic> tests = json['tests'];

    // Iterate over tests
    for (var test in tests) {
      bool hasData = false;
      double? reactiveMTime;
      double? fTime;
      double? bTime;
      double? lTime;
      double? rTime;

      double? staticTLSolidML;
      double? staticTLFoamML;

      double? dynamicT1Duration;
      double? dynamicT1TurnSpeed;
      double? dynamicT1MLSway;

      double? dynamicT2Duration;
      double? dynamicT2TurnSpeed;
      double? dynamicT2MLSway;

      double? dynamicT3Duration;
      double? dynamicT3TurnSpeed;
      double? dynamicT3MLSway;

      double? dMax;
      double? dMin;
      double? dMean;
      double? dMedian;
      double? tsMax;
      double? tsMin;
      double? tsMean;
      double? tsMedian;
      double? mlMax;
      double? mlMin;
      double? mlMean;
      double? mlMedian;

      // Get reactive test data
      if (test.containsKey('reactive')) {
        if (test['reactive'].length != 0) {
          reactiveMTime = test['reactive']['mTime'];
          fTime = test['reactive']['fTime'];
          bTime = test['reactive']['bTime'];
          lTime = test['reactive']['lTime'];
          rTime = test['reactive']['rTime'];
          hasData = true;
        }
      }
      // Get static test data
      else if (test.containsKey('static')) {
        if (test['static'].length != 0) {
          staticTLSolidML = test['static']['tlSolidML'];
          staticTLFoamML = test['static']['tlFoamML'];
          hasData = true;
        }
      }
      // Get dynamic test data
      else if (test.containsKey('dynamic')) {
        if (test['dynamic'].length != 0) {
          dynamicT1Duration = test['dynamic']['t1Duration'];
          dynamicT1TurnSpeed = test['dynamic']['t1TurnSpeed'];
          dynamicT1MLSway = test['dynamic']['t1MLSway'];

          dynamicT2Duration = test['dynamic']['t2Duration'];
          dynamicT2TurnSpeed = test['dynamic']['t2TurnSpeed'];
          dynamicT2MLSway = test['dynamic']['t2MLSway'];

          dynamicT3Duration = test['dynamic']['t3Duration'];
          dynamicT3TurnSpeed = test['dynamic']['t3TurnSpeed'];
          dynamicT3MLSway = test['dynamic']['t3MLSway'];

          dMax = test['dynamic']['dMax'];
          dMin = test['dynamic']['dMin'];
          dMean = test['dynamic']['dMean'];
          dMedian = test['dynamic']['dMedian'];

          tsMax = test['dynamic']['tsMax'];
          tsMin = test['dynamic']['tsMin'];
          tsMean = test['dynamic']['tsMean'];
          tsMedian = test['dynamic']['tsMedian'];

          mlMax = test['dynamic']['mlMax'];
          mlMin = test['dynamic']['mlMin'];
          mlMean = test['dynamic']['mlMean'];
          mlMedian = test['dynamic']['mlMedian'];

          hasData = true;
        }
      }

      List<dynamic> row;

      if (hasData) {
        row = [
          json['thirdPartyID'],
          json['iName'],
          json['iDate'],
          json['iNotes'],
          reactiveMTime,
          fTime,
          bTime,
          lTime,
          rTime,
          staticTLSolidML,
          staticTLFoamML,
          dynamicT1Duration,
          dynamicT1TurnSpeed,
          dynamicT1MLSway,
          dynamicT2Duration,
          dynamicT2TurnSpeed,
          dynamicT2MLSway,
          dynamicT3Duration,
          dynamicT3TurnSpeed,
          dynamicT3MLSway,
          dMax,
          dMin,
          dMean,
          dMedian,
          tsMax,
          tsMin,
          tsMean,
          tsMedian,
          mlMax,
          mlMin,
          mlMean,
          mlMedian,
        ];
        rows.add(row);

        // Condense csv rows to group related data
        if (processedJson.containsKey(test['tID'])) {
          int headerIndex = 0;
          for (var col in row) {
            if (processedJson[test['tID']]?[csvHeader[headerIndex]] == null &&
                col != null) {
              processedJson[test['tID']]![csvHeader[headerIndex]] = col;
            }
            headerIndex++;
          }
        } else {
          int headerIndex = 0;
          for (var col in row) {
            if (processedJson[test['tID']] == null) {
              processedJson[test['tID']] = {};
            }
            processedJson[test['tID']]![csvHeader[headerIndex++]] = col;
          }
        }
      }
    }
  }
  return processedJson;
}

// void exportIMUData(String fileName, Map<String, dynamic> json) async {
//   List<List<dynamic>> rows = [];
//   Map<int, Map<String, dynamic>> processedJson = {};

//   // Parse JSON

//   rows.add(csvHeader);
//   // Reorder the row data so that it matches the csv column order
//   processedJson.forEach((test, row) {
//     List<dynamic> orderedRow = [];
//     for (String header in csvHeader) {
//       orderedRow.add(row[header]);
//     }
//     rows.add(orderedRow);
//   });

//   // Export patient data
//   String csv = const ListToCsvConverter().convert(rows);
//   String fileContent = csv;
//   XFile csvFile = await createCSVFile(fileName, fileContent);
//   await exportCSV(csvFile);
// }

/* ------------------------------------- CSV ------------------------------------- */

Future<XFile> createCSVFile(String fileName, String fileContent) async {
  final dir = await getApplicationDocumentsDirectory();
  final csvFile = File('${dir.path}/$fileName.csv');
  await csvFile.writeAsString(fileContent);
  final xCsvFile = XFile('${dir.path}/$fileName.csv');
  return xCsvFile;
}

Future<void> exportCSV(XFile file) async {
  Share.shareXFiles([file]);
}
