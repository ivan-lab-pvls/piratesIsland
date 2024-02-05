import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../router/router.dart';
import '../../theme.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.push(SettingsRoute()),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: blueColor2,
            border: Border.all(width: 4, color: blueColor3),
            borderRadius: const BorderRadius.all(Radius.circular(16))),
        child: SvgPicture.asset('assets/icons/settings.svg'),
      ),
    );
  }
}
