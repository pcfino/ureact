import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

/// Holds accelerometer fields.
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

/// Holds gyroscope fields.
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

/// Holds the results of the sensor recorder.
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

/// IMU data is recorded here.
class StaticDynamicRecorder {
  late SensorRecorderResults _results;
  late bool _killTimer;

  double _gyroX = 0.0;
  double _gyroY = 0.0;
  double _gyroZ = 0.0;

  double _accX = 0.0;
  double _accY = 0.0;
  double _accZ = 0.0;

  late bool _staticTest;

  StaticDynamicRecorder(bool staticTest) {
    _staticTest = staticTest;
    gyroscopeEventStream(samplingPeriod: SensorInterval.fastestInterval)
        .listen((event) {
      _gyroX = event.y;
      _gyroY = event.x;
      _gyroZ = event.z;
    });

    accelerometerEventStream(samplingPeriod: SensorInterval.fastestInterval)
        .listen((event) {
      _accX = event.y;
      _accY = event.x;
      _accZ = event.z;
    });

    startRecording();
  }

  SensorRecorderResults endRecording() {
    if (_staticTest) {
      FlutterRingtonePlayer().play(
        android: AndroidSounds.notification,
        ios: IosSounds.glass,
        looping: false, // Android only - API >= 28
        volume: 0.8, // Android only - API >= 28
        asAlarm: false, // Android only - all APIs
      );
    }

    _killTimer = true;
    return _results;
  }

  void startRecording() {
    FlutterRingtonePlayer().play(
      android: AndroidSounds.notification,
      ios: IosSounds.glass,
      looping: false, // Android only - API >= 28
      volume: 0.8, // Android only - API >= 28
      asAlarm: false, // Android only - all APIs
    );

    const samplePeriod = 20; // ms
    const sampleDuration = Duration(milliseconds: samplePeriod);

    _killTimer = false;

    _results = SensorRecorderResults(samplePeriod);

    Timer.periodic(sampleDuration, (timer) async {
      if (_killTimer) {
        timer.cancel();
      }

      _results.accData.x.add(_accX);
      _results.accData.y.add(_accY);
      _results.accData.z.add(_accZ);

      _results.gyrData.x.add(_gyroX);
      _results.gyrData.y.add(_gyroY);
      _results.gyrData.z.add(_gyroZ);

      _results.timeStamps.add(DateTime.now().millisecondsSinceEpoch);
    });
  }
}
