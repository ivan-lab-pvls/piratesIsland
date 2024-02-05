import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pirate/features/settings/settings_screen.dart';
import 'package:pirate/features/shared/game_screen.dart';
import 'package:pirate/features/shared/widgets/minimize_widget.dart';
import 'package:pirate/features/shared/widgets/stroke_title.dart';
import 'package:pirate/game_enum.dart';
import 'package:pirate/theme.dart';
import 'package:vibration/vibration.dart';

import '../../../economics.dart';
import '../../balance/balance_functions.dart';
import '../../shared/game_controller.dart';
import '../../shared/game_status.dart';
import '../../shared/widgets/button.dart';
import '../../shared/widgets/minimize_title.dart';
import '../../shared/widgets/shake_widget.dart';
import 'pokies_machine.dart';

var ableToRestart = false;
final _pokiesMachineShakeKey = GlobalKey<ShakeWidgetState>();
final _pokiesBalanceShakeKey = GlobalKey<ShakeWidgetState>();
bool showMachine = true;

@RoutePage()
class PokiesScreen extends StatefulWidget {
  const PokiesScreen({super.key});

  @override
  State<PokiesScreen> createState() => _PokiesScreenState();
}

class _PokiesScreenState extends State<PokiesScreen> {
  late PokiesMachineController _pokiesController;
  late PokiesController _gameController;
  late ConfettiController _confettiController;

  @override
  void initState() {
    _gameController = PokiesController();
    _confettiController =
        ConfettiController(duration: const Duration(milliseconds: 800));
    super.initState();
  }

  @override
  void dispose() {
    _gameController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void onButtonTap() {
    _gameController.increment(_pokiesController);
  }

  void onStart() {
    ableToRestart = false;
    final index = Random().nextInt(100);
    _pokiesController.start(hitRollItemIndex: index < 10 ? index : null);
  }

  @override
  Widget build(BuildContext context) {
    return GameScreen(
        game: Game.pokies,
        controller: _gameController,
        balanceShakeKey: _pokiesBalanceShakeKey,
        gameRestartCallback: (_) {
          _gameController.startGame();
          if (isBalanceSufficient()) {
            onStart();
            _gameController.restart();
          } else {
            _pokiesBalanceShakeKey.currentState!.shake();
          }
        },
        children: [
          GetBuilder(
            init: _gameController,
            builder: (controller) {
              return MinimizeWidget(
                  condition: _gameController.stopIndex != 4 ||
                      _gameController.gameStatus == GameStatus.initial,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 3.2,
                      height: MediaQuery.of(context).size.height / 2.1,
                      decoration: const BoxDecoration(
                        color: blueColor3,
                      ),
                    ),
                    ShakeWidget(
                      key: _pokiesMachineShakeKey,
                      shakeCount: 3,
                      shakeOffset: 10,
                      shakeDuration: const Duration(milliseconds: 400),
                      child: !showMachine
                          ? const CupertinoActivityIndicator()
                          : PokiesMachine(
                              reelWidth: MediaQuery.of(context).size.width / 15,
                              reelHeight:
                                  MediaQuery.of(context).size.height / 2.25,
                              rollItems: List.generate(4, (index) {
                                return RollItem(
                                  index: index,
                                  child: Image.asset('assets/items/$index.png'),
                                );
                              }),
                              onCreated: (controller) {
                                _pokiesController = controller;
                              },
                              onFinished: (resultIndexes) async {
                                if (resultIndexes[0] == resultIndexes[1] &&
                                    resultIndexes[1] == resultIndexes[2] &&
                                    resultIndexes[2] == resultIndexes[3]) {
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
                                  _confettiController.play();
                                  await _gameController.endGame(GameStatus.win,
                                      slotPokiesWinReward * additionalCoef);
                                  if (settingsController.vibro) {
                                    Vibration.vibrate(
                                        pattern: [100, 1000, 500, 2000],
                                        intensities: [1, 255]);
                                  }
                                } else {
                                  await _gameController.endGame(
                                      GameStatus.lose, gameCost);
                                  _pokiesMachineShakeKey.currentState?.shake();
                                }
                              },
                            ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3.2,
                      height: MediaQuery.of(context).size.height / 3.5.sp,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(width: 4, color: blueColor3)),
                    ),
                  ]);
            },
          ),
          GetBuilder(
            init: _gameController,
            builder: (_) {
              return MinimizeTitle(
                condition: _gameController.stopIndex != 4 ||
                    _gameController.gameStatus == GameStatus.initial,
                strokeTitle: const StrokeTitle(
                  text: 'MACHINE',
                  strokeWidth: 2,
                  fontSize: 25,
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
            child: GetBuilder<PokiesController>(
              init: _gameController,
              builder: (_) {
                if (_gameController.stopIndex == 4 &&
                    _gameController.gameStatus != GameStatus.initial) {
                  return const SizedBox.shrink();
                }
                if (_gameController.stopIndex < 4) {
                  return Button(
                    callback: (p0) => onButtonTap(),
                    child: Text('STOP', style: smallTS),
                  );
                } else {
                  return Button(
                    callback: (p0) {
                      _gameController.startGame();
                      if (isBalanceSufficient()) {
                        onStart();
                        _gameController.restart();
                      } else {
                        _pokiesBalanceShakeKey.currentState!.shake();
                      }
                    },
                    child: Text('SPIN', style: smallTS),
                  );
                }
              },
            ),
          ),
        ]);
  }
}

class PokiesController extends GameController {
  int stopIndex = 4;
  void increment(PokiesMachineController controller) {
    if (stopIndex < 4) {
      controller.stop(reelIndex: stopIndex);
      stopIndex++;
      update();
    }
  }

  void restart() {
    stopIndex = 0;
    update();
  }
}
