import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';

class AccelerometerData {
  late final List<double> x;
  late final List<double> y;
  late final List<double> z;

  AccelerometerData() {
    x = <double>[];
    y = <double>[];
    z = <double>[];
  }
}

class PatientAngle {
  late double angle = 0.0;
  late Color color = Color.fromRGBO(255, 220, 212, 1);

  double _accX = 0.0;
  double _accY = 0.0;
  double _accZ = 0.0;

  double _init_accX = double.nan;
  double _init_accY = double.nan;
  double _init_accZ = double.nan;

  String _testDirection = '';

  late StreamSubscription<AccelerometerEvent> _accelerometerStreamEvent;

  PatientAngle(String testDirection) {
    _testDirection = testDirection;

    _accelerometerStreamEvent = accelerometerEventStream().listen((event) {
      _accX = event.y;
      _accY = event.x;
      _accZ = event.z;
      if (_init_accX.isNaN) {
        _init_accX = event.y;
        _init_accY = event.x;
        _init_accZ = event.z;
      }
      angleMeet([_accX, _accY, _accZ]);
    });
  }

  void endSensors() {
    _accelerometerStreamEvent.cancel();
  }

  ///Takes in a set of cords for this time stamp.
  ///Checks if the angle has been met.
  void angleMeet(cord) {
    double minAngle = 0.0;
    double maxAngle = 0.0;
    double radAngle = 0.0;
    double initAngle = 0.0;
    double x = cord[0];
    double y = cord[1];
    double z = cord[2];
    if (_testDirection == 'Backward') {
      // Initially 90 - 8
      minAngle = 5; //90 - 9;
      // Inititally 90 - 6
      maxAngle = 9; //90 - 5;
      radAngle = acos(z / sqrt((x * x) + (y * y) + (z * z)));
      initAngle = acos(_init_accZ /
          sqrt((_init_accX * _init_accX) +
              (_init_accY * _init_accY) +
              (_init_accZ * _init_accZ)));
    } else if (_testDirection == 'Forward') {
      // Inititally 45 + 8
      minAngle = -11; //45 + 7;
      // Initially 45 + 10
      maxAngle = -7; //45 + 11;
      radAngle = acos(z / sqrt((x * x) + (y * y) + (z * z)));
      initAngle = acos(_init_accZ /
          sqrt((_init_accX * _init_accX) +
              (_init_accY * _init_accY) +
              (_init_accZ * _init_accZ)));
    } else if (_testDirection == 'Left') {
      minAngle = -12;
      maxAngle = -8;
      radAngle = atan(x / sqrt((y * y) + (z * z)));
      initAngle = atan(_init_accX /
          sqrt((_init_accY * _init_accY) + (_init_accZ * _init_accZ)));
    } else if (_testDirection == 'Right') {
      minAngle = 8;
      maxAngle = 12;
      radAngle = atan(x / sqrt((y * y) + (z * z)));
      initAngle = atan(_init_accX /
          sqrt((_init_accY * _init_accY) + (_init_accZ * _init_accZ)));
    } else {
      print("$_testDirection is not a valid test direction");
    }

    minAngle = minAngle * pi / 180;
    maxAngle = maxAngle * pi / 180;
    // print("rad angle is: " + radAngle.toString());

    angle = radAngle;

    if (radAngle >= initAngle + minAngle && radAngle <= initAngle + maxAngle) {
      color = Colors.green;
    } else if (radAngle > initAngle + maxAngle ||
        radAngle < initAngle + minAngle) {
      color = Colors.yellow;
    }

    // print("angle is:" + angle.toString());
  }
}
