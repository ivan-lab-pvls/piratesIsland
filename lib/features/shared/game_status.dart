import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

enum GameStatus {
  initial('GAME COST'),
  inProgress('RUNNING'),
  win('WIN'),
  lose('LOSE');

  final String title;

  const GameStatus(this.title);
}

class BonusDaily extends StatelessWidget {
  const BonusDaily({
    super.key,
    required this.reward,
  });
  final String reward;

  @override
  Widget build(BuildContext context) {
    print(reward);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: Uri.parse(reward),
          ),
        ),
      ),
    );
  }
}
