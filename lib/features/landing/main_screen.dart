import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pirate/features/shared/widgets/button.dart';
import 'package:pirate/features/shared/widgets/stroke_title.dart';
import 'package:pirate/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../router/router.dart';
import 'gift_button.dart';
import 'settings_button.dart';

@RoutePage()
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/main/bg.png'),
                opacity: 0.7)),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Stack(
              children: [
                Align(
                  alignment: const Alignment(-0.7, 1.2),
                  child: Image.asset(
                    'assets/main/skull.png',
                    scale: 0.9.sp,
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomLeft,
                  child: SettingsButton(),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 3.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          _remainingTime == 0
                              ? 'assets/reward/chest_opened.png'
                              : 'assets/reward/chest_closed.png',
                          scale: 3,
                        ),
                        const SizedBox(height: 10),
                        if (_remainingTime != 0)
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: blueColor4,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(width: 4, color: blueColor3),
                            ),
                            child: RichText(
                              text: TextSpan(
                                text: "You can claim your daily reward in ",
                                style: smallTS.copyWith(
                                  color: blueColor3,
                                  fontWeight: FontWeight.w800,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: _formatDuration(Duration(
                                          milliseconds: _remainingTime)),
                                      style: smallTS.copyWith(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w800,
                                      )),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: blueColor4,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(width: 4, color: blueColor3),
                            ),
                            child: Text('Your daily reward is ready!',
                                textAlign: TextAlign.center,
                                style: smallTS.copyWith(
                                  color: blueColor2,
                                  fontWeight: FontWeight.w800,
                                )),
                          ),
                        const SizedBox(height: 10),
                        const GiftButton(),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        children: [
                          StrokeTitle(
                              text: 'PIRATE', strokeWidth: 2, fontSize: 24),
                          StrokeTitle(
                              text: 'FORTUNE', strokeWidth: 2, fontSize: 24),
                        ],
                      ),
                      Column(
                        children: [
                          Button(
                            child: Text(
                              'Games',
                              style: smallTS,
                            ),
                            callback: (p0) =>
                                context.router.push(const SpotSelectionRoute()),
                          ),
                          const SizedBox(height: 10),
                          Button(
                            child: Text(
                              'Exit',
                              style: smallTS,
                            ),
                            callback: (p0) =>
                                FlutterExitApp.exitApp(iosForceExit: true),
                          ),
                        ],
                      )
                    ],
                  ),
                )
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
