import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MinimizeTitle extends StatelessWidget {
  final bool condition;
  final Widget strokeTitle;
  const MinimizeTitle(
      {super.key, required this.condition, required this.strokeTitle});

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: condition ? 1 : 0.5,
      duration: const Duration(milliseconds: 500),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedPositioned(
              top: 0,
              bottom: 0,
              left: condition ? 0 : -150.w,
              right: 0,
              duration: const Duration(milliseconds: 500),
              child: condition ? const SizedBox.shrink() : strokeTitle),
        ],
      ),
    );
  }
}
