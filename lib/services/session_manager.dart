import 'dart:async';

class SessionManagerService {
  Timer? _timer;
  bool _isRunning = false;

  void start(Function callback, Duration interval) {
    if (!_isRunning) {
      _timer = Timer.periodic(interval, (Timer t) => callback());
      _isRunning = true;
    }
  }

  void stop() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
      _isRunning = false;
    }
  }
}
