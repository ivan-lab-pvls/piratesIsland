import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../../theme.dart';

class StrokeTitle extends StatelessWidget {
  final String text;
  final double? strokeWidth;
  final int? fontSize;
  const StrokeTitle(
      {super.key, required this.text, this.strokeWidth, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return StrokeText(
      text: text,
      strokeColor: blueColor3,
      strokeWidth: strokeWidth == null ? 3.sp : strokeWidth!.sp,
      textStyle:
          fontSize == null ? largeTS : largeTS.copyWith(fontSize: fontSize!.sp),
    );
  }
}
