import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';

import '../../../economics.dart';
import '../../../theme.dart';
import '../game_controller.dart';
import '../game_status.dart';

class StatusBoard extends StatelessWidget {
  final GameController controller;

  const StatusBoard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: blueColor4,
        border: Border.all(width: 8, color: blueColor3),
      ),
      child: FittedBox(
        child: Column(
          children: [
            GetBuilder<GameController>(
              init: controller,
              builder: (_) {
                return Text(
                  controller.gameStatus.title,
                  style: mediumTS.copyWith(color: yellowColor, fontSize: 8.sp),
                );
              },
            ),
            SizedBox(height: 10.h),
            GetBuilder<GameController>(
              init: controller,
              builder: (_) {
                if (controller.gameStatus == GameStatus.inProgress) {
                  return const CupertinoActivityIndicator(color: blueColor3);
                } else if (controller.gameStatus == GameStatus.initial) {
                  return Text(
                    gameCost.abs().toString(),
                    style: smallTS.copyWith(fontSize: 10.sp),
                  );
                } else {
                  return Text(controller.balanceResult.toString(),
                      style: smallTS.copyWith(fontSize: 10.sp));
                }
              },
            ),
            SizedBox(height: 10.h),
            Legenda(),
          ],
        ),
      ),
    );
  }
}

class Legenda extends StatelessWidget {
  Legenda({super.key});
  final List<Widget> multiplierWidgets = [];

  @override
  Widget build(BuildContext context) {
    for (var gift in Gift.values) {
      multiplierWidgets.add(
        Container(
          width: MediaQuery.of(context).size.width / 6,
          height: MediaQuery.of(context).size.width / 18,
          padding: const EdgeInsets.only(right: 10, left: 10),
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: blueColor3, width: 8))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                gift.imagePath,
                height: 25.sp,
                width: 25.sp,
              ),
              Text('x${gift.value}', style: smallTS),
            ],
          ),
        ),
      );
    }
    return Column(
      children: [...multiplierWidgets],
    );
  }
}
