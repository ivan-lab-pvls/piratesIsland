import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kbspinningwheel/kbspinningwheel.dart';
import 'package:pirate/economics.dart';
import 'package:pirate/features/shared/game_screen.dart';
import 'package:pirate/features/shared/widgets/minimize_title.dart';
import 'package:pirate/features/shared/widgets/minimize_widget.dart';
import 'package:pirate/features/shared/widgets/stroke_title.dart';
import 'package:pirate/game_enum.dart';

import '../../../theme.dart';
import '../../balance/balance_functions.dart';
import '../../shared/game_controller.dart';
import '../../shared/widgets/button.dart';
import '../../shared/widgets/shake_widget.dart';
import '../../shared/game_status.dart';

final _rouletteBalanceShakeKey = GlobalKey<ShakeWidgetState>();

@RoutePage()
class RouletteScreen extends StatefulWidget {
  const RouletteScreen({super.key});

  @override
  State<RouletteScreen> createState() => _RouletteScreenState();
}

class _RouletteScreenState extends State<RouletteScreen> {
  final _dividerController = StreamController<int>();
  final _wheelNotifier = StreamController<double>();
  late RouletteController _gameController;

  @override
  void initState() {
    super.initState();

    _gameController = RouletteController();
  }

  @override
  void dispose() {
    _dividerController.close();
    _wheelNotifier.close();
    _gameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GameScreen(
        gameRestartCallback: (p0) => spinWheel(),
        balanceShakeKey: _rouletteBalanceShakeKey,
        controller: _gameController,
        game: Game.roulette,
        children: [
          GetBuilder(
            init: _gameController,
            builder: (_) {
              return MinimizeWidget(
                  condition: _gameController.giftIndex == -1,
                  children: [
                    SpinningWheel(
                      image: Image.asset(
                        'assets/roulette/roulette.png',
                      ),
                      width: 310,
                      height: 310,
                      initialSpinAngle: 0,
                      spinResistance: 0.6,
                      canInteractWhileSpinning: false,
                      dividers: 14,
                      onUpdate: (_) {
                        _dividerController.add(_);
                      },
                      onEnd: (index) async {
                        _dividerController.add(index);
                        _gameController.toggleSpin();
                        await _gameController.setNewGiftIndex(index);
                      },
                      shouldStartOrStop: _wheelNotifier.stream,
                      stopSpin: true,
                    ),
                    Transform.rotate(
                      angle: pi / 12,
                      child: SvgPicture.asset('assets/roulette/pointer.svg'),
                    ),
                  ]);
            },
          ),
          GetBuilder(
            init: _gameController,
            builder: (_) {
              return MinimizeTitle(
                  condition: _gameController.giftIndex == -1,
                  strokeTitle: const StrokeTitle(
                    text: '',
                    strokeWidth: 2,
                    fontSize: 17,
                  ));
            },
          ),
          GetBuilder<RouletteController>(
            init: _gameController,
            builder: (_) {
              if (_gameController.giftIndex == -1 &&
                  !_gameController.spinning) {
                return Align(
                    alignment: Alignment.centerLeft,
                    child: Button(
                        callback: (p0) {
                          spinWheel();
                        },
                        child: Text('SPIN', style: smallTS)));
              } else {
                return const SizedBox.shrink();
              }
            },
          )
        ]);
  }

  void spinWheel() {
    if (!_gameController.spinning) {
      if (isBalanceSufficient()) {
        updateBalance(gameCost);
        _gameController.startGame();
        _wheelNotifier.sink.add(_generateRandomVelocity());
        _gameController.toggleSpin();
        _gameController.setInitialGiftIndex();
      } else {
        _rouletteBalanceShakeKey.currentState!.shake();
      }
    }
  }

  double _generateRandomVelocity() => (Random().nextDouble() * 6000) + 6000;
}

class RouletteController extends GameController {
  int giftIndex = -1;
  bool spinning = false;
  void toggleSpin() {
    spinning = !spinning;
    update();
  }

  void setInitialGiftIndex() {
    giftIndex = -1;
    update();
  }

  Future<void> setNewGiftIndex(index) async {
    giftIndex = index;
    var a = WheelGift.values[giftIndex - 1];
    await endGame(
        GameStatus.win,
        int.parse(
            (a.gift.value * gameCost.abs()).toString().replaceAll('.0', '')));

    update();
  }
}
