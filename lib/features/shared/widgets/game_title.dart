import 'package:flutter/material.dart';

import '../../../theme.dart';

class GameTitle extends StatelessWidget {
  final String gameTitle;

  const GameTitle({super.key, required this.gameTitle});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Text(gameTitle, style: Theme.of(context).textTheme.titleSmall),
      ),
    );
  }
}
