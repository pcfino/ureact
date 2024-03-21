import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:event/event.dart';

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

class GyroscopeData {
  late final List<double> x;
  late final List<double> y;
  late final List<double> z;

  GyroscopeData() {
    x = <double>[];
    y = <double>[];
    z = <double>[];
  }
}

class SensorRecorderResults {
  late final AccelerometerData accData;
  late final GyroscopeData gyrData;
  late final List<int> timeStamps;
  late final int fs;

  SensorRecorderResults(samplePeriod) {
    accData = AccelerometerData();
    gyrData = GyroscopeData();
    timeStamps = <int>[];
    fs = (1000 / samplePeriod).round();
  }

  List<List<double>> formattedAccData() {
    return [accData.x, accData.y, accData.z];
  }

  List<List<double>> formattedGyrData() {
    return [gyrData.x, gyrData.y, gyrData.z];
  }
}

class ReactiveSensorRecorder {
  // late final Stream<AccelerometerEvent> _accStream;
  // late final Stream<GyroscopeEvent> _gyrStream;
  // late final List<StreamSubscription> _streamSubscriptions;
  late SensorRecorderResults? _results;
  late bool _killTimer;

  double _gyroX = 0.0;
  double _gyroY = 0.0;
  double _gyroZ = 0.0;

  double _accX = 0.0;
  double _accY = 0.0;
  double _accZ = 0.0;

  bool _ready = false;
  String _testDirection = '';

  late bool _running;
  late bool _done;

  late Timer? preTimer;
  late StreamSubscription<GyroscopeEvent> _gyroscopeStreamEvent;
  late StreamSubscription<AccelerometerEvent> _accelerometerStreamEvent;
  late Event stopEvent;

  ReactiveSensorRecorder(String testDirection) {
    stopEvent = Event();

    _running = false;
    _done = false;
    _testDirection = testDirection;

    _results = null;

    _gyroscopeStreamEvent = gyroscopeEventStream().listen((event) {
      _gyroX = event.y;
      _gyroY = event.x;
      _gyroZ = event.z;
      //print("gyroscope: $_gyroX, $_gyroY, $_gyroZ");
    });

    _accelerometerStreamEvent = accelerometerEventStream().listen((event) {
      _accX = event.y;
      _accY = event.x;
      _accZ = event.z;
      //print("accelerometer: $_accX, $_accY, $_accZ");
    });

    const samplePeriod = 20; // ms
    int angleMetTime = 0;
    preTimer = Timer.periodic(const Duration(milliseconds: samplePeriod),
        (preTimer) async {
      if (_ready) {
        //print(angleMetTime);
        // After 3 seconds in correct position
        if (angleMetTime == 150) {
          FlutterRingtonePlayer.play(
            android: AndroidSounds.notification,
            ios: IosSounds.chime,
            looping: true, // Android only - API >= 28
            volume: 0.8, // Android only - API >= 28
            asAlarm: false, // Android only - all APIs
          );
          startRecording();
          _running = true;
          preTimer.cancel();
          //print('cancel');
        } else if (angleMetTime % 50 == 0) {
          FlutterRingtonePlayer.play(
            android: AndroidSounds.notification,
            ios: IosSounds.electronic,
            looping: true, // Android only - API >= 28
            volume: 0.8, // Android only - API >= 28
            asAlarm: false, // Android only - all APIs
          );
        }
        angleMetTime += 1;
      } else {
        angleMetTime = 0;
      }
      angleMeet([_accX, _accY, _accZ]);
    });
  }

  void cancelPreTimer() {
    if (preTimer != null) {
      preTimer!.cancel();
    }
  }

  bool getRunning() {
    return _running;
  }

  bool getDone() {
    return _done;
  }

  SensorRecorderResults endRecording() {
    _done = true;
    _killTimer = true;
    _running = false;
    endSensors();
    // for (final subscription in _streamSubscriptions) {
    //   subscription.cancel();
    // }
    //debugPrint((_results.gyrData.x.length.toString()));w
    try {
      return _results!;
      // ignore: empty_catches
    } catch (e) {
      throw Exception();
    }
  }

  void endSensors() {
    _accelerometerStreamEvent.cancel();
    _gyroscopeStreamEvent.cancel();
  }

  void startRecording() {
    //_stream.cancel();
    const samplePeriod = 20; // ms
    const sampleDuration = Duration(milliseconds: samplePeriod);
    //Timer(const Duration(seconds: 3), () => FlutterRingtonePlayer.stop());

    _killTimer = false;

    _results = SensorRecorderResults(samplePeriod);

    const motionlessThreshold = 10.4967;
    int counter = 0;
    bool dropped = false;

    Timer.periodic(sampleDuration, (timer) async {
      if (_killTimer) {
        timer.cancel();
      }

      double norm = sqrt(_accX * _accX + _accY * _accY + _accZ * _accZ);
      // If the participant has not been dropped yet and they are moving more
      // than the motionless threshold, set dropped to true
      // Else if they have been dropped and are now less than the motionless
      // threshold, we start a counter. After 1 second, we broadcast the results
      // Else if they have been dropped and their motion is greater than the
      // motionless threshold, keep the counter at 0
      if (!dropped && norm > motionlessThreshold) {
        dropped = true;
      } else if (dropped && norm < motionlessThreshold) {
        counter++;
        if (counter == 50) {
          stopEvent.broadcast();
        }
      } else {
        counter = 0;
      }

      _results!.accData.x.add(_accX);
      _results!.accData.y.add(_accY);
      _results!.accData.z.add(_accZ);

      _results!.gyrData.x.add(_gyroX);
      _results!.gyrData.y.add(_gyroY);
      _results!.gyrData.z.add(_gyroZ);

      _results!.timeStamps.add(DateTime.now().millisecondsSinceEpoch);
    });
  }

  void angleMeet(cord) {
    double minAngle = 0;
    double maxAngle = 0;
    double radAngle = 0;
    double x = cord[0];
    double y = cord[1];
    double z = cord[2];
    if (_testDirection == 'backward') {
      // Initially 90 - 8
      minAngle = 90 - 9;
      // Inititally 90 - 6
      maxAngle = 90 - 5;
      radAngle = acos(z / sqrt((x * x) + (y * y) + (z * z)));
    } else if (_testDirection == 'forward') {
      // Inititally 45 + 8
      minAngle = 45 + 7;
      // Initially 45 + 10
      maxAngle = 45 + 11;
      radAngle = acos(z / sqrt((x * x) + (y * y) + (z * z)));
    } else if (_testDirection == 'left') {
      minAngle = 8;
      maxAngle = 12;
      radAngle = atan(x / sqrt((y * y) + (z * z)));
    } else if (_testDirection == 'right') {
      minAngle = -12;
      maxAngle = -8;
      radAngle = atan(x / sqrt((y * y) + (z * z)));
    } else {
      print("$_testDirection is not a valid test direction");
    }

    minAngle = minAngle * pi / 180;
    maxAngle = maxAngle * pi / 180;

    if (radAngle >= minAngle && radAngle <= maxAngle) {
      _ready = true;
    } else {
      _ready = false;
    }
    //print(_ready);
    //angleMeet([_accX, _accY, _accZ], front, back, left, right);
  }
}
