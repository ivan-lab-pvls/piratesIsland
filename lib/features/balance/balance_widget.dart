import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../main.dart';
import '../../theme.dart';
import '../shared/widgets/shake_widget.dart';

class BalanceWidget extends StatelessWidget {
  final GlobalKey<ShakeWidgetState> shakeKey;
  const BalanceWidget({super.key, required this.shakeKey});

  @override
  Widget build(BuildContext context) {
    return ShakeWidget(
      key: shakeKey,
      shakeCount: 3,
      shakeOffset: 10,
      shakeDuration: const Duration(milliseconds: 400),
      child: ValueListenableBuilder<int>(
        valueListenable: creditBalance,
        builder: (context, value, child) {
          return FittedBox(
            child: Container(
              padding: const EdgeInsets.only(right: 30, left: 30),
              decoration: BoxDecoration(
                  color: blueColor4,
                  border: Border.all(width: 8, color: blueColor3)),
              child: Column(
                children: [
                  Text('BALANCE',
                      style:
                          largeTS.copyWith(fontSize: 8.sp, color: yellowColor)),
                  Text(value.toString(), style: smallTS),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
