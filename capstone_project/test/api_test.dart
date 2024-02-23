import 'package:test/test.dart';
import 'package:capstone_project/api/patient_api.dart';
import 'package:capstone_project/models/patient.dart';

// to run all tests in test folder, do: flutter test
// to run specific tests: flutter test --plain-name "Verify Create Patient"

void main() {
  test('Verify Create Patient', () async {
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
}
