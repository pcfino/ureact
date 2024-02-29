import 'package:test/test.dart';
import 'package:capstone_project/api/patient_api.dart';
import 'package:capstone_project/models/patient.dart';

// to run all tests in test folder, do: flutter test
// to run specific tests: flutter test --plain-name "Test Patients"

void main() {
  group('Test Patients', () {
    List<int> pIDs = [];
    test('Verify Create Patient', () async {
      dynamic jsonPatient = await create({
        "firstName": "Test",
        "lastName": "Testerson",
        "dOB": "1001-02-15",
        "height": 60,
        "weight": 195,
        "sport": "Lacrosse",
        "gender": "M",
        "thirdPartyID": "12345"
      });
      if (jsonPatient["pID"] != Null) {
        pIDs.add(jsonPatient["pID"]);
      }

      expect(jsonPatient["pID"], isNotNull);

      bool deletedPatient = await delete(jsonPatient["pID"]);
      expect(deletedPatient, true);
    });

    test('Verify get Patient', () async {
      dynamic jsonPatient = await create({
        "firstName": "Test",
        "lastName": "Testing",
        "dOB": "1001-02-15",
        "height": 60,
        "weight": 195,
        "sport": "Lacrosse",
        "gender": "M",
        "thirdPartyID": "12345"
      });
      pIDs.add(jsonPatient["pID"]);
      Patient patientInserted = Patient.fromJson(jsonPatient);

      var createdPatient = await get(patientInserted.pID);
      Patient patientGotten = Patient.fromJson(createdPatient[0]);

      expect(patientGotten.pID, patientInserted.pID);
      expect(patientGotten.firstName, "Test");
      expect(patientGotten.lastName, "Testing");
      expect(patientGotten.dOB, "1001-02-15");
      expect(patientGotten.height, 60);
      expect(patientGotten.weight, 195);
      expect(patientGotten.sport, "Lacrosse");
      expect(patientGotten.gender, "M");
      expect(patientGotten.thirdPartyID, "12345");

      bool deletedPatient = await delete(patientInserted.pID);
      expect(deletedPatient, true);
    });

    test('Verify getAll Patients', () async {
      dynamic jsonPatient1 = await create({
        "firstName": "Test",
        "lastName": "Testing",
        "dOB": "1001-02-15",
        "height": 60,
        "weight": 195,
        "sport": "Lacrosse",
        "gender": "M",
        "thirdPartyID": "12345"
      });
      dynamic jsonPatient2 = await create({
        "firstName": "Test",
        "lastName": "Testing Jr.",
        "dOB": "1020-02-15",
        "height": 61,
        "weight": 200,
        "sport": "Lacrosse",
        "gender": "M",
        "thirdPartyID": "123456"
      });
      dynamic jsonPatient3 = await create({
        "firstName": "Test",
        "lastName": "Testing Jr. Jr.",
        "dOB": "1030-02-15",
        "height": 63,
        "weight": 210,
        "sport": "Lacrosse",
        "gender": "M",
        "thirdPartyID": "1234567"
      });
      pIDs.add(jsonPatient1["pID"]);
      pIDs.add(jsonPatient2["pID"]);
      pIDs.add(jsonPatient3["pID"]);

      Patient patient_1 = Patient.fromJson(jsonPatient1);
      Patient patient_2 = Patient.fromJson(jsonPatient2);
      Patient patient_3 = Patient.fromJson(jsonPatient3);

      var createdPatient = await getAll();

      bool patient_1_exists = false;
      bool patient_2_exists = false;
      bool patient_3_exists = false;
      for (var x in createdPatient) {
        if (patient_1.pID == x["pID"]) {
          patient_1_exists = true;
        }
        if (patient_2.pID == x["pID"]) {
          patient_2_exists = true;
        }
        if (patient_3.pID == x["pID"]) {
          patient_3_exists = true;
        }
      }
      expect(patient_1_exists, true);
      expect(patient_2_exists, true);
      expect(patient_3_exists, true);

      bool deletedPatient1 = await delete(patient_1.pID);
      bool deletedPatient2 = await delete(patient_2.pID);
      bool deletedPatient3 = await delete(patient_3.pID);
      expect(deletedPatient1, true);
      expect(deletedPatient2, true);
      expect(deletedPatient3, true);
    });

    test('Verify Update Patient FName', () async {
      dynamic jsonPatient = await create({
        "firstName": "Test",
        "lastName": "Testerson",
        "dOB": "1001-02-15",
        "height": 60,
        "weight": 195,
        "sport": "Lacrosse",
        "gender": "M",
        "thirdPartyID": "12345"
      });
      pIDs.add(jsonPatient["pID"]);

      expect(jsonPatient["pID"], isNotNull);

      dynamic updatePatient =
          await update(jsonPatient["pID"], {"firstName": "NewTest"});

      Patient patientGotten = Patient.fromJson(updatePatient);

      expect(patientGotten.pID, jsonPatient["pID"]);
      expect(patientGotten.firstName, "NewTest");
      expect(patientGotten.lastName, "Testerson");
      expect(patientGotten.dOB, "1001-02-15");
      expect(patientGotten.height, 60);
      expect(patientGotten.weight, 195);
      expect(patientGotten.sport, "Lacrosse");
      expect(patientGotten.gender, "M");
      expect(patientGotten.thirdPartyID, "12345");

      bool deletedPatient = await delete(jsonPatient["pID"]);
      expect(deletedPatient, true);
    });

    test('Verify Update Patient LName', () async {
      dynamic jsonPatient = await create({
        "firstName": "Test",
        "lastName": "Testerson",
        "dOB": "1001-02-15",
        "height": 60,
        "weight": 195,
        "sport": "Lacrosse",
        "gender": "M",
        "thirdPartyID": "12345"
      });
      pIDs.add(jsonPatient["pID"]);

      expect(jsonPatient["pID"], isNotNull);

      dynamic updatePatient =
          await update(jsonPatient["pID"], {"lastName": "NewTesterson"});

      Patient patientGotten = Patient.fromJson(updatePatient);

      expect(patientGotten.pID, jsonPatient["pID"]);
      expect(patientGotten.firstName, "Test");
      expect(patientGotten.lastName, "NewTesterson");
      expect(patientGotten.dOB, "1001-02-15");
      expect(patientGotten.height, 60);
      expect(patientGotten.weight, 195);
      expect(patientGotten.sport, "Lacrosse");
      expect(patientGotten.gender, "M");
      expect(patientGotten.thirdPartyID, "12345");

      bool deletedPatient = await delete(jsonPatient["pID"]);
      expect(deletedPatient, true);
    });

    test('Verify Update Patient DOB', () async {
      dynamic jsonPatient = await create({
        "firstName": "Test",
        "lastName": "Testerson",
        "dOB": "1001-02-15",
        "height": 60,
        "weight": 195,
        "sport": "Lacrosse",
        "gender": "M",
        "thirdPartyID": "12345"
      });
      pIDs.add(jsonPatient["pID"]);

      expect(jsonPatient["pID"], isNotNull);

      dynamic updatePatient =
          await update(jsonPatient["pID"], {"dOB": "1010-02-15"});

      Patient patientGotten = Patient.fromJson(updatePatient);

      expect(patientGotten.pID, jsonPatient["pID"]);
      expect(patientGotten.firstName, "Test");
      expect(patientGotten.lastName, "Testerson");
      expect(patientGotten.dOB, "1010-02-15");
      expect(patientGotten.height, 60);
      expect(patientGotten.weight, 195);
      expect(patientGotten.sport, "Lacrosse");
      expect(patientGotten.gender, "M");
      expect(patientGotten.thirdPartyID, "12345");

      bool deletedPatient = await delete(jsonPatient["pID"]);
      expect(deletedPatient, true);
    });

    test('Verify Update Patient height', () async {
      dynamic jsonPatient = await create({
        "firstName": "Test",
        "lastName": "Testerson",
        "dOB": "1001-02-15",
        "height": 60,
        "weight": 195,
        "sport": "Lacrosse",
        "gender": "M",
        "thirdPartyID": "12345"
      });
      pIDs.add(jsonPatient["pID"]);

      expect(jsonPatient["pID"], isNotNull);

      dynamic updatePatient = await update(jsonPatient["pID"], {"height": 65});

      Patient patientGotten = Patient.fromJson(updatePatient);

      expect(patientGotten.pID, jsonPatient["pID"]);
      expect(patientGotten.firstName, "Test");
      expect(patientGotten.lastName, "Testerson");
      expect(patientGotten.dOB, "1001-02-15");
      expect(patientGotten.height, 65);
      expect(patientGotten.weight, 195);
      expect(patientGotten.sport, "Lacrosse");
      expect(patientGotten.gender, "M");
      expect(patientGotten.thirdPartyID, "12345");

      bool deletedPatient = await delete(jsonPatient["pID"]);
      expect(deletedPatient, true);
    });

    test('Verify Update Patient weight', () async {
      dynamic jsonPatient = await create({
        "firstName": "Test",
        "lastName": "Testerson",
        "dOB": "1001-02-15",
        "height": 60,
        "weight": 195,
        "sport": "Lacrosse",
        "gender": "M",
        "thirdPartyID": "12345"
      });
      pIDs.add(jsonPatient["pID"]);

      expect(jsonPatient["pID"], isNotNull);

      dynamic updatePatient = await update(jsonPatient["pID"], {"weight": 100});

      Patient patientGotten = Patient.fromJson(updatePatient);

      expect(patientGotten.pID, jsonPatient["pID"]);
      expect(patientGotten.firstName, "Test");
      expect(patientGotten.lastName, "Testerson");
      expect(patientGotten.dOB, "1001-02-15");
      expect(patientGotten.height, 60);
      expect(patientGotten.weight, 100);
      expect(patientGotten.sport, "Lacrosse");
      expect(patientGotten.gender, "M");
      expect(patientGotten.thirdPartyID, "12345");

      bool deletedPatient = await delete(jsonPatient["pID"]);
      expect(deletedPatient, true);
    });

    test('Verify Update Patient sport', () async {
      dynamic jsonPatient = await create({
        "firstName": "Test",
        "lastName": "Testerson",
        "dOB": "1001-02-15",
        "height": 60,
        "weight": 195,
        "sport": "Lacrosse",
        "gender": "M",
        "thirdPartyID": "12345"
      });
      pIDs.add(jsonPatient["pID"]);

      expect(jsonPatient["pID"], isNotNull);

      dynamic updatePatient =
          await update(jsonPatient["pID"], {"sport": "Football"});

      Patient patientGotten = Patient.fromJson(updatePatient);

      expect(patientGotten.pID, jsonPatient["pID"]);
      expect(patientGotten.firstName, "Test");
      expect(patientGotten.lastName, "Testerson");
      expect(patientGotten.dOB, "1001-02-15");
      expect(patientGotten.height, 60);
      expect(patientGotten.weight, 195);
      expect(patientGotten.sport, "Football");
      expect(patientGotten.gender, "M");
      expect(patientGotten.thirdPartyID, "12345");

      bool deletedPatient = await delete(jsonPatient["pID"]);
      expect(deletedPatient, true);
    });

    test('Verify Update Patient gender', () async {
      dynamic jsonPatient = await create({
        "firstName": "Test",
        "lastName": "Testerson",
        "dOB": "1001-02-15",
        "height": 60,
        "weight": 195,
        "sport": "Lacrosse",
        "gender": "M",
        "thirdPartyID": "12345"
      });
      pIDs.add(jsonPatient["pID"]);

      expect(jsonPatient["pID"], isNotNull);

      dynamic updatePatient = await update(jsonPatient["pID"], {"gender": "F"});

      Patient patientGotten = Patient.fromJson(updatePatient);

      expect(patientGotten.pID, jsonPatient["pID"]);
      expect(patientGotten.firstName, "Test");
      expect(patientGotten.lastName, "Testerson");
      expect(patientGotten.dOB, "1001-02-15");
      expect(patientGotten.height, 60);
      expect(patientGotten.weight, 195);
      expect(patientGotten.sport, "Lacrosse");
      expect(patientGotten.gender, "F");
      expect(patientGotten.thirdPartyID, "12345");

      bool deletedPatient = await delete(jsonPatient["pID"]);
      expect(deletedPatient, true);
    });

    test('Verify Update Patient tpID', () async {
      dynamic jsonPatient = await create({
        "firstName": "Test",
        "lastName": "Testerson",
        "dOB": "1001-02-15",
        "height": 60,
        "weight": 195,
        "sport": "Lacrosse",
        "gender": "M",
        "thirdPartyID": "12345"
      });
      pIDs.add(jsonPatient["pID"]);

      expect(jsonPatient["pID"], isNotNull);

      dynamic updatePatient =
          await update(jsonPatient["pID"], {"thirdPartyID": "11111"});

      Patient patientGotten = Patient.fromJson(updatePatient);

      expect(patientGotten.pID, jsonPatient["pID"]);
      expect(patientGotten.firstName, "Test");
      expect(patientGotten.lastName, "Testerson");
      expect(patientGotten.dOB, "1001-02-15");
      expect(patientGotten.height, 60);
      expect(patientGotten.weight, 195);
      expect(patientGotten.sport, "Lacrosse");
      expect(patientGotten.gender, "M");
      expect(patientGotten.thirdPartyID, "11111");

      bool deletedPatient = await delete(jsonPatient["pID"]);
      expect(deletedPatient, true);
    });

    // format:

    // this will always run at the end, so I can always delete patients if a test case fails
    tearDown(() async {
      // Delete the patient
      for (var x in pIDs) {
        await delete(x);
      }
    });
    // this is the end of the patient group
  });
}
