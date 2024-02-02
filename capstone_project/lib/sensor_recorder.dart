import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

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

class SensorRecorder {
  // late final Stream<AccelerometerEvent> _accStream;
  // late final Stream<GyroscopeEvent> _gyrStream;
  // late final List<StreamSubscription> _streamSubscriptions;
  late SensorRecorderResults _results;
  late bool _killTimer;
  late StreamSubscription<AccelerometerEvent> _stream;

  double _gyroX = 0.0;
  double _gyroY = 0.0;
  double _gyroZ = 0.0;

  double _accX = 0.0;
  double _accY = 0.0;
  double _accZ = 0.0;

  bool _ready = false;
  String _testDirection = '';

  SensorRecorder(String testDirection) {
    // _streamSubscriptions = <StreamSubscription>[];

    /*while(!ready) {
      () async{
        var accEvent = await accelerometerEventStream().first;
        ready = angleMeet(accEvent, false, true, false, false);
      };
    }*/
    //_stream = accelerometerEventStream().listen((AccelerometerEvent event) {
    //angleMeet(<double>[event.x, event.y, event.z], false, true, false, false);
    //});

    // _accStream =
    //     Sensors().accelerometerEventStream(samplingPeriod: sampleDuration);
    // _gyrStream = Sensors().gyroscopeEventStream(samplingPeriod: sampleDuration);

    // _streamSubscriptions.add(_accStream.listen((event) {
    //   var x = event.x;
    //   var y = event.y;
    //   var z = event.z;

    //   debugPrint('accData:  $x  $y  $z');
    // }));

    // _streamSubscriptions.add(_gyrStream.listen((event) {
    //   var x = event.x;
    //   var y = event.y;
    //   var z = event.z;

    //   debugPrint('gyrData:  $x  $y  $z');
    // }));

    _testDirection = testDirection;

    gyroscopeEventStream().listen((event) {
      _gyroX = event.x;
      _gyroY = event.y;
      _gyroZ = event.z;
    });

    accelerometerEventStream().listen((event) {
      _accX = event.x;
      _accY = event.y;
      _accZ = event.z;
    });

    const samplePeriod = 20; // ms
    Timer.periodic(const Duration(milliseconds: samplePeriod), (timer) async {
      if (_ready) {
        timer.cancel();
      }
      angleMeet([_accX, _accY, _accZ]);
    });
  }

  SensorRecorderResults endRecording() {
    _killTimer = true;
    // for (final subscription in _streamSubscriptions) {
    //   subscription.cancel();
    // }
    //debugPrint((_results.gyrData.x.length.toString()));
    return _results;
  }

  void startRecording() {
    //_stream.cancel();
    const samplePeriod = 20; // ms
    const sampleDuration = Duration(milliseconds: samplePeriod);
    Timer(const Duration(seconds: 3), () => FlutterRingtonePlayer.stop());

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

  void angleMeet(cord) {
    double minAngle = 0;
    double maxAngle = 0;
    double radAngle = 0;
    double x = cord[0];
    double y = cord[1];
    double z = cord[2];
    if (_testDirection == 'backward') {
      minAngle = 90 - 8;
      maxAngle = 90 - 6;
      radAngle = acos(z / sqrt((x * x) + (y * y) + (z * z)));
    } else if (_testDirection == 'forward') {
      minAngle = 45 + 8;
      maxAngle = 45 + 10;
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
      FlutterRingtonePlayer.play(
        android: AndroidSounds.notification,
        ios: IosSounds.glass,
        looping: true, // Android only - API >= 28
        volume: 0.8, // Android only - API >= 28
        asAlarm: false, // Android only - all APIs
      );
      startRecording();
      _ready = true;
    }
    //angleMeet([_accX, _accY, _accZ], front, back, left, right);
  }
}
