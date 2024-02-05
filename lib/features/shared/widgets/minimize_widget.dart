import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MinimizeWidget extends StatelessWidget {
  final bool condition;
  final List<Widget> children;
  const MinimizeWidget(
      {super.key, required this.condition, required this.children});

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: condition ? 0.4.sp : 0.2.sp,
      duration: const Duration(milliseconds: 500),
      // child: AnimatedAlign(
      //     alignment: condition ? Alignment.center : Alignment.centerLeft,
      //     duration: const Duration(milliseconds: 500),
      //     child: Stack(
      //       alignment: Alignment.center,
      //       children: [...children],
      //     )),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedPositioned(
              top: 0,
              bottom: 0,
              left: condition ? 0 : -1100,
              right: 0,
              duration: const Duration(milliseconds: 500),
              child: Stack(
                alignment: Alignment.center,
                children: [...children],
              )),
        ],
      ),
    );
  }
}
