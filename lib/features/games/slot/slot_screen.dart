import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pirate/theme.dart';
import 'package:vibration/vibration.dart';

import '../../../economics.dart';
import '../../../game_enum.dart';
import '../../balance/balance_functions.dart';
import '../../settings/settings_screen.dart';
import '../../shared/game_controller.dart';
import '../../shared/game_screen.dart';
import '../../shared/game_status.dart';
import '../../shared/widgets/button.dart';
import '../../shared/widgets/minimize_title.dart';
import '../../shared/widgets/minimize_widget.dart';
import '../../shared/widgets/shake_widget.dart';
import '../../shared/widgets/stroke_title.dart';
import 'slot_machine.dart';

final _slotMachineShakeKey = GlobalKey<ShakeWidgetState>();
final _slotBalanceShakeKey = GlobalKey<ShakeWidgetState>();
bool showMachine = true;

@RoutePage()
class SlotScreen extends StatefulWidget {
  const SlotScreen({super.key});

  @override
  State<SlotScreen> createState() => _SlotScreenState();
}

class _SlotScreenState extends State<SlotScreen>
    with SingleTickerProviderStateMixin {
  late SlotMachineController _slotsController;
  late SlotController _gameController;
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool isRotated = false;

  @override
  void initState() {
    super.initState();
    _gameController = SlotController();
    _confettiController =
        ConfettiController(duration: const Duration(milliseconds: 800));
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation =
        Tween<double>(begin: 0, end: pi / 2).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _gameController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void rotateImage() {
    if (isRotated) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    setState(() {
      isRotated = !isRotated;
    });
  }

  void onStart() {
    if (_gameController.ableToRestart) {
      _gameController.startGame();
      _gameController.changeStatus();
      final index = Random().nextInt(100);
      _slotsController.start(hitRollItemIndex: index < 4 ? index : null);
      Future.delayed(const Duration(milliseconds: 500), () {
        _slotsController.stop(reelIndex: 0);
      });
      Future.delayed(const Duration(milliseconds: 1000), () {
        _slotsController.stop(reelIndex: 1);
      });
      Future.delayed(const Duration(milliseconds: 1500), () {
        _slotsController.stop(reelIndex: 2);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GameScreen(
        game: Game.slot,
        controller: _gameController,
        balanceShakeKey: _slotBalanceShakeKey,
        gameRestartCallback: (_) {
          if (isBalanceSufficient()) {
            _gameController.changeStatus();
            _gameController.startGame();
            onStart();
            _gameController.changeStatus();
            _animationController.forward();
            Future.delayed(const Duration(milliseconds: 1000), () {
              _animationController.reverse();
            });
          } else {
            _slotBalanceShakeKey.currentState!.shake();
          }
        },
        children: [
          GetBuilder(
            init: _gameController,
            builder: (controller) {
              return MinimizeWidget(
                  condition: _gameController.ableToRestart ||
                      _gameController.gameStatus == GameStatus.initial,
                  children: [
                    GetBuilder(
                      init: _gameController,
                      builder: (_) {
                        return Padding(
                          padding: EdgeInsets.only(left: 16.sp, bottom: 6.sp),
                          child: AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) => Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..rotateX(_animation.value),
                              child: SvgPicture.asset(
                                'assets/spots/machine1.svg',
                                width:
                                    MediaQuery.of(context).size.width / 0.75.sp,
                                height: MediaQuery.of(context).size.height /
                                    0.75.sp,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 6.sp),
                      child: SvgPicture.asset(
                        'assets/spots/machine.svg',
                        width: MediaQuery.of(context).size.width / 0.75.sp,
                        height: MediaQuery.of(context).size.height / 0.75.sp,
                      ),
                    ),
                    ShakeWidget(
                      key: _slotMachineShakeKey,
                      shakeCount: 3,
                      shakeOffset: 10,
                      shakeDuration: const Duration(milliseconds: 400),
                      child: SlotMachine(
                        reelWidth: MediaQuery.of(context).size.width / 20,
                        reelHeight: MediaQuery.of(context).size.height / 0.9.sp,
                        reelSpacing:
                            MediaQuery.of(context).size.height / 4.5.sp,
                        rollItems: List.generate(4, (index) {
                          return RollItem(
                            index: index,
                            child: Image.asset('assets/items/$index.png'),
                          );
                        }),
                        onCreated: (controller) {
                          _slotsController = controller;
                        },
                        onFinished: (resultIndexes) async {
                          if (resultIndexes[0] == resultIndexes[1] &&
                              resultIndexes[1] == resultIndexes[2]) {
                            int additionalCoef = 0;
                            switch (resultIndexes[0]) {
                              case 0:
                                additionalCoef = Gift.chest.value;
                                break;
                              case 1:
                                additionalCoef = Gift.crown.value;
                                break;
                              case 2:
                                additionalCoef = Gift.coins.value;
                                break;
                              case 3:
                                additionalCoef = Gift.coin.value;
                                break;
                            }
                            await Future.delayed(
                                const Duration(milliseconds: 300));
                            _confettiController.play();
                            await _gameController.endGame(GameStatus.win,
                                slotPokiesWinReward * additionalCoef);
                            if (settingsController.vibro) {
                              Vibration.vibrate(
                                  pattern: [100, 1000, 500, 2000],
                                  intensities: [1, 255]);
                            }
                          } else {
                            await Future.delayed(
                                const Duration(milliseconds: 300));
                            _slotMachineShakeKey.currentState?.shake();
                            await _gameController.endGame(
                                GameStatus.lose, gameCost);
                          }
                          _gameController.changeStatus();
                        },
                      ),
                    ),
                  ]);
            },
          ),
          GetBuilder(
            init: _gameController,
            builder: (_) {
              return MinimizeTitle(
                condition: _gameController.ableToRestart ||
                    _gameController.gameStatus == GameStatus.initial,
                strokeTitle: const StrokeTitle(
                  text: 'TURBO',
                  strokeWidth: 2,
                  fontSize: 20,
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              numberOfParticles: 20,
              emissionFrequency: 0.5,
              blastDirectionality: BlastDirectionality.explosive,
              gravity: 0.3,
              colors: const [
                blueColor1,
                blueColor2,
                blueColor3,
                blueColor4,
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: GetBuilder<SlotController>(
              init: _gameController,
              builder: (_) {
                if (_gameController.ableToRestart &&
                    _gameController.gameStatus != GameStatus.inProgress) {
                  return Button(
                    callback: (p0) {
                      if (isBalanceSufficient()) {
                        _gameController.startGame();
                        onStart();
                        _gameController.changeStatus();
                        _animationController.forward();
                        Future.delayed(const Duration(milliseconds: 1000), () {
                          _animationController.reverse();
                        });
                      } else {
                        _slotBalanceShakeKey.currentState!.shake();
                      }
                    },
                    child: Text('SPIN', style: smallTS),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ]);
  }
}

class SlotController extends GameController {
  bool ableToRestart = true;
  void changeStatus() {
    ableToRestart = !ableToRestart;
    update();
  }
}
