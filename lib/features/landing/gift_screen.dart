import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pirate/features/shared/widgets/stroke_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../economics.dart';
import '../../main.dart';
import '../../theme.dart';
import '../balance/balance_functions.dart';
import '../shared/widgets/back_buttonn.dart';
import '../shared/widgets/button.dart';

@RoutePage()
class GiftScreen extends StatefulWidget {
  const GiftScreen({Key? key}) : super(key: key);

  @override
  _GiftScreenState createState() => _GiftScreenState();
}

class _GiftScreenState extends State<GiftScreen> {
  late Timer _timer;
  int _remainingTime = 0;

  @override
  void initState() {
    super.initState();
    _checkRemainingTime();
    _startTimer();
  }

  Future<void> _checkRemainingTime() async {
    final rewardCooldown =
        locator<SharedPreferences>().getInt('rewardCooldown')!;
    // print('$_remainingTime, $rewardCooldown');
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now < rewardCooldown) {
      setState(() {
        _remainingTime = rewardCooldown - now;
      });
    } else {
      setState(() {
        _remainingTime = 0;
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _checkRemainingTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _setRewardExpirationTime() async {
    final now = DateTime.now();
    final tomorrow = DateTime(
        now.year, now.month, now.day + 1, now.hour, now.minute, now.second);
    final millisecondsSinceEpoch = tomorrow.millisecondsSinceEpoch;

    await locator<SharedPreferences>()
        .setInt('rewardCooldown', millisecondsSinceEpoch);
    _checkRemainingTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: blueColor1,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Stack(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: BackButtonn(isActive: true),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 3.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const StrokeTitle(text: 'DAILY REWARD'),
                        _remainingTime != 0
                            ? RichText(
                                text: TextSpan(
                                text: "You got your ",
                                style: smallTS,
                                children: <TextSpan>[
                                  TextSpan(
                                      text: dailyReward.toString(),
                                      style:
                                          smallTS.copyWith(color: Colors.red)),
                                  TextSpan(
                                      text:
                                          " coins daily bonus today. Come again in ",
                                      style: smallTS),
                                  TextSpan(
                                      text: _formatDuration(Duration(
                                          milliseconds: _remainingTime)),
                                      style:
                                          smallTS.copyWith(color: blueColor2)),
                                ],
                              ))
                            : RichText(
                                text: TextSpan(
                                text: "Every ",
                                style: smallTS,
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "24 hours",
                                      style:
                                          smallTS.copyWith(color: blueColor2)),
                                  TextSpan(
                                      text: " you can get your daily reward",
                                      style: smallTS),
                                ],
                              )),
                        const SizedBox(height: 10),
                        _remainingTime != 0
                            ? Button(
                                child: Text('OPEN', style: smallTS),
                              )
                            : Button(
                                callback: (p0) {
                                  updateBalance(dailyReward);
                                  _setRewardExpirationTime();
                                },
                                child: Text('OPEN', style: smallTS),
                              )
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(-0.3, 0.0),
                  child: CustomPaint(
                      foregroundPainter:
                          CircleBlurPainter(circleWidth: 200, blurSigma: 25)),
                ),
                Align(
                  alignment: const Alignment(-0.4, 0.0),
                  child: Image.asset(
                    _remainingTime == 0
                        ? 'assets/reward/chest_opened.png'
                        : 'assets/reward/chest_closed.png',
                    scale: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.remainder(24).toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}

class CircleBlurPainter extends CustomPainter {
  CircleBlurPainter({required this.circleWidth, required this.blurSigma});

  double circleWidth;
  double blurSigma;

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = Paint()
      ..color = const Color.fromRGBO(255, 233, 177, 1)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = circleWidth
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma);
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, line);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
