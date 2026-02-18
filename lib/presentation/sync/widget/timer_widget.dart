import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimerWidget extends StatefulWidget {

  /// مثال: "01:30"
  final String time;

  /// الأكشن عند انتهاء التايمر
  final VoidCallback? onFinished;

  const CountdownTimerWidget({
    super.key,
    required this.time,
    this.onFinished,
  });

  @override
  State<CountdownTimerWidget> createState() =>
      _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {

  Timer? _timer;
  late Duration _duration;

  @override
  void initState() {
    super.initState();
    _duration = _parseTime(widget.time);
    _startCountdown();
  }

  /// إذا تغيّر state.time من Bloc
  @override
  void didUpdateWidget(covariant CountdownTimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.time != widget.time) {
      _timer?.cancel();
      _duration = _parseTime(widget.time);
      _startCountdown();
    }
  }

  Duration _parseTime(String time) {
    try {
      final parts = time.split(":");

      final minutes = int.parse(parts[0]);
      final seconds = int.parse(parts[1]);

      return Duration(
        minutes: minutes,
        seconds: seconds,
      );
    } catch (_) {
      return Duration.zero;
    }
  }

  void _startCountdown() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_duration.inSeconds > 0) {
        setState(() {
          _duration -= const Duration(seconds: 1);
        });
      } else {
        timer.cancel();
        _onTimerFinished();
      }
    });
  }

  void _onTimerFinished() {
    // 🔥 الأكشن عند انتهاء الوقت
    widget.onFinished?.call();

    // مثال افتراضي
    debugPrint("Timer Finished");
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));

    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDuration(_duration),
      textAlign: TextAlign.end,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}