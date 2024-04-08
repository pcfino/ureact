import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:capstone_project/api/export_api.dart' as export_api;

bool isPatient = false;

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
    isPatient = true;
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

/* ------------------------------------- Export Methods ------------------------------------- */

void exportPatient(int pID) async {
  String fileName = "";
  Map<String, dynamic> json = {};
  List<dynamic> jsonList = await export_api.exportPatient(pID);

  if (jsonList.isNotEmpty) {
    json = jsonList.first;

    if (json.containsKey('thirdPartyID')) {
      fileName = "patient${json['thirdPartyID']}";
    }

    exportData(fileName, json);
  }
}

void exportIncident(int pID, int iID) async {
  String fileName = "";
  Map<String, dynamic> json = {};
  List<dynamic> jsonList = await export_api.exportIncident(pID, iID);

  if (jsonList.isNotEmpty) {
    json = jsonList.first;

    if (json.containsKey('thirdPartyID')) {
      if (json.containsKey('iName') && json.containsKey('iDate')) {
        fileName =
            "patient${json['thirdPartyID']}_${json['iName']}_${json['iDate']}";
      }
    }

    exportData(fileName, json);
  }
}

void exportTest(int pID, int tID) async {
  // print("pID is: " + pID.toString());
  // print("tID is: " + tID.toString());
  String fileName = "";
  Map<String, dynamic> json = {};
  List<dynamic> jsonList = await export_api.exportTest(pID, tID);

  if (jsonList.isNotEmpty) {
    json = jsonList.first;

    if (json.containsKey('thirdPartyID')) {
      if (json.containsKey('iName') && json.containsKey('iDate')) {
        fileName =
            "patient${json['thirdPartyID']}_${json['iName']}_${json['iDate']}_tests";
      }
    }

    exportData(fileName, json);
  }
}

void exportData(String fileName, Map<String, dynamic> json) async {
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
