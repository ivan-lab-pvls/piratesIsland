import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pirate/features/shared/game_controller.dart';
import 'package:pirate/game_enum.dart';

import '../../router/router.dart';
import '../../theme.dart';
import '../balance/balance_widget.dart';
import 'game_status.dart';
import 'widgets/back_buttonn.dart';
import 'widgets/button.dart';
import 'widgets/status_board.dart';
import 'widgets/stroke_title.dart';

class GameScreen extends StatefulWidget {
  final Function(dynamic) gameRestartCallback;
  final Game game;
  final controller;
  final balanceShakeKey;
  final List<Widget> children;
  const GameScreen(
      {super.key,
      required this.children,
      required this.game,
      required this.controller,
      required this.balanceShakeKey,
      required this.gameRestartCallback});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/main/bg.png'),
                fit: BoxFit.cover,
                opacity: 0.7)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SafeArea(
            child: Stack(children: [
              Align(
                alignment: Alignment.topLeft,
                child: GetBuilder<GameController>(
                  init: widget.controller,
                  builder: (_) {
                    return BackButtonn(
                        isActive: widget.controller.gameStatus !=
                            GameStatus.inProgress);
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: StatusBoard(controller: widget.controller),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: BalanceWidget(shakeKey: widget.balanceShakeKey),
              ),
              GetBuilder<GameController>(
                init: widget.controller,
                builder: (_) {
                  if (widget.controller.gameStatus == GameStatus.win ||
                      widget.controller.gameStatus == GameStatus.lose) {
                    return Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StrokeTitle(
                              text: 'YOU ${widget.controller.gameStatus.title}',
                              strokeWidth: 2),
                          Text((widget.controller.balanceResult).toString(),
                              style: smallTS.copyWith(fontSize: 20.sp)),
                          Button(
                            child: Text('Play again', style: smallTS),
                            callback: (p0) =>
                                widget.gameRestartCallback('Argument'),
                          ),
                          const SizedBox(height: 10),
                          Button(
                            child: Text('Main menu', style: smallTS),
                            callback: (p0) => context.router.pushAndPopUntil(
                                const MainRoute(),
                                predicate: (_) => false),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              ...widget.children
            ]),
          ),
        ),
      ),
    );
  }
}
