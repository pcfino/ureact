import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:event/event.dart';
import 'package:audioplayers/audioplayers.dart';

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

  double _init_accX = double.nan;
  double _init_accY = double.nan;
  double _init_accZ = double.nan;

  bool _ready = false;
  String _testDirection = '';

  late bool _running;
  late bool _done;

  late Timer? preTimer;
  late StreamSubscription<GyroscopeEvent> _gyroscopeStreamEvent;
  late StreamSubscription<AccelerometerEvent> _accelerometerStreamEvent;
  late Event stopEvent;
  late AudioPlayer player;

  /*
  *Iintializes the Sensor Recorder
  *Sets Up Zero Angle to match start
  *Begins checking angles
  */
  ReactiveSensorRecorder(String testDirection) {
    stopEvent = Event();

    FlutterRingtonePlayer.play(
      android: AndroidSounds.notification,
      ios: IosSounds.chime,
      looping: false, // Android only - API >= 28
      volume: 0.8, // Android only - API >= 28
      asAlarm: false, // Android only - all APIs
    );

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
      if (_init_accX.isNaN) {
        _init_accX = event.y;
        _init_accY = event.x;
        _init_accZ = event.z;
      }
      //print("accelerometer: $_accX, $_accY, $_accZ");
    });

    const samplePeriod = 20; // ms
    int angleMetTime = 0;
    player = AudioPlayer();
    const successSoundPath = "sounds/Success.mp3";
    const failureSoundPath = "sounds/Failure.mp3";

    //starts a sequence that checks for the angle of patient
    preTimer = Timer.periodic(const Duration(milliseconds: samplePeriod),
        (preTimer) async {
      if (_ready) {
        // After 2 seconds in correct position
        if (angleMetTime == 100) {
          startRecording();
          _running = true;
          preTimer.cancel();
        } else {
          player.play(AssetSource(successSoundPath));
        }
        angleMetTime += 1;
      } else {
        //stops the player for the success sound if move out of range
        player.stop();
        //player.play(AssetSource(failureSoundPath));
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

  /*
   * Ends the current results and sends that to the Front End
   */
  SensorRecorderResults endRecording() {
    _done = true;
    _killTimer = true;
    _running = false;
    endSensors();
    // for (final subscription in _streamSubscriptions) {
    //   subscription.cancel();
    // }
    debugPrint(_results!.toString());
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

  /*
  * Starts the recording of data after the correct angle has been met.
  * Checks for when stability has been reached, and stops recording data.
  * Sends signal to front end telling it the recording is done.
  */
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
        player.stop();
      } else if (dropped && norm < motionlessThreshold) {
        counter++;
        if (counter == 100) {
          FlutterRingtonePlayer.play(
            android: AndroidSounds.notification,
            ios: IosSounds.chime,
            looping: false, // Android only - API >= 28
            volume: 0.8, // Android only - API >= 28
            asAlarm: false, // Android only - all APIs
          );
          stopEvent.broadcast();
        }
      } else {
        counter = 0;
      }

      _results!.accData.x.add(_accY);
      _results!.accData.y.add(_accX);
      _results!.accData.z.add(_accZ);

      _results!.gyrData.x.add(_gyroY);
      _results!.gyrData.y.add(_gyroX);
      _results!.gyrData.z.add(_gyroZ);

      _results!.timeStamps.add(DateTime.now().millisecondsSinceEpoch);
    });
  }

  ///Takes in a set of cords for this time stamp.
  ///Checks if the angle has been met.
  void angleMeet(cord) {
    double minAngle = 0;
    double maxAngle = 0;
    double radAngle = 0;
    double initAngle = 0;
    double x = cord[0];
    double y = cord[1];
    double z = cord[2];
    //Added 5 degrees to each to match what was working with forward
    if (_testDirection == 'backward') {
      // Initially 6
      minAngle = 6;
      // Inititally 8
      maxAngle = 9;
      radAngle = acos(z / sqrt((x * x) + (y * y) + (z * z)));
      initAngle = acos(_init_accZ /
          sqrt((_init_accX * _init_accX) +
              (_init_accY * _init_accY) +
              (_init_accZ * _init_accZ)));
      //During Meeting we found that around -16 was the angle we needed
    } else if (_testDirection == 'forward') {
      // Inititally 8
      minAngle = -10; //45 + 7; //-16 to -12 worked well with peter in the room
      // Initially 10
      maxAngle = -8; //45 + 11;
      radAngle = acos(z / sqrt((x * x) + (y * y) + (z * z)));
      initAngle = acos(_init_accZ /
          sqrt((_init_accX * _init_accX) +
              (_init_accY * _init_accY) +
              (_init_accZ * _init_accZ)));
    } else if (_testDirection == 'right') {
      minAngle = -7;
      maxAngle = -5;
      radAngle = atan(x / sqrt((y * y) + (z * z)));
      initAngle = atan(_init_accX /
          sqrt((_init_accY * _init_accY) + (_init_accZ * _init_accZ)));
    } else if (_testDirection == 'left') {
      minAngle = 5;
      maxAngle = 7;
      radAngle = atan(x / sqrt((y * y) + (z * z)));
      initAngle = atan(_init_accX /
          sqrt((_init_accY * _init_accY) + (_init_accZ * _init_accZ)));
    } else {
      print("$_testDirection is not a valid test direction");
    }

    minAngle = minAngle * pi / 180;
    maxAngle = maxAngle * pi / 180;

    if (radAngle >= initAngle + minAngle && radAngle <= initAngle + maxAngle) {
      _ready = true;
    } else {
      _ready = false;
    }
    //print(_ready);
    //angleMeet([_accX, _accY, _accZ], front, back, left, right);
  }
}
