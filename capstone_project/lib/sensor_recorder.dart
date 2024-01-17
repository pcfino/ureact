import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

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
  late final SensorRecorderResults _results;
  late bool _killTimer;

  SensorRecorder() {
    // _streamSubscriptions = <StreamSubscription>[];
    _killTimer = false;

    const samplePeriod = 20; // ms
    const sampleDuration = Duration(milliseconds: samplePeriod);
    _results = SensorRecorderResults(samplePeriod);

    Timer.periodic(sampleDuration, (timer) async {
      if (_killTimer) {
        timer.cancel();
      }

      var accEvent = await accelerometerEventStream().first;
      _results.accData.x.add(accEvent.x);
      _results.accData.y.add(accEvent.y);
      _results.accData.z.add(accEvent.z);

      var gyrEvent = await gyroscopeEventStream().first;
      _results.gyrData.x.add(gyrEvent.x);
      _results.gyrData.y.add(gyrEvent.y);
      _results.gyrData.z.add(gyrEvent.z);

      _results.timeStamps.add(DateTime.now().millisecondsSinceEpoch);
    });

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
  }

  SensorRecorderResults endRecording() {
    _killTimer = true;
    // for (final subscription in _streamSubscriptions) {
    //   subscription.cancel();
    // }
    return _results;
  }
}
