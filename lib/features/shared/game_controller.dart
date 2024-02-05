import 'package:get/get.dart';
import 'package:pirate/features/settings/settings_screen.dart';
import 'package:vibration/vibration.dart';

import '../balance/balance_functions.dart';
import 'game_status.dart';

class GameController extends GetxController {
  GameStatus gameStatus = GameStatus.initial;
  int balanceResult = 0;
  void startGame() {
    gameStatus = GameStatus.inProgress;
    balanceResult = 0;
    if (settingsController.vibro) {
      Vibration.vibrate(pattern: [100, 1000, 500, 2000], intensities: [1, 255]);
    }
  }

  Future<void> endGame(GameStatus result, int balanceUpdate) async {
    Future.delayed(const Duration(milliseconds: 700), () async {
      gameStatus = result;
      balanceResult += balanceUpdate;
      await updateBalance(balanceResult);
      update();
    });
  }
}
