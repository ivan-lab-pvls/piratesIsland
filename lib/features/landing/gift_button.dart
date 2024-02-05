import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pirate/theme.dart';

import '../../router/router.dart';

class GiftButton extends StatelessWidget {
  const GiftButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.push(const GiftRoute()),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: blueColor2,
            border: Border.all(width: 4, color: blueColor3),
            borderRadius: const BorderRadius.all(Radius.circular(16))),
        child: Text(
          'Claim →',
          style: smallTS,
        ),
      ),
    );
  }
}
