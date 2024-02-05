import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../shared/widgets/button.dart';

class GameWidget extends StatelessWidget {
  final String gameName;
  final String gameImagePath;
  final Function(dynamic) callback;

  const GameWidget(
      {super.key,
      required this.gameName,
      required this.callback,
      required this.gameImagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/landing/game_frame.png'))),
      width: MediaQuery.of(context).size.width / 4,
      height: MediaQuery.of(context).size.height / 1.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            gameImagePath,
            scale: gameName == 'ROULETTE' ? 1.7 : 1.2,
          ),
          Padding(
            padding: EdgeInsets.only(top: 40.h),
            child: Text(gameName,
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Button(
                callback: callback,
                child: Text('PLAY',
                    style: Theme.of(context).textTheme.titleMedium)),
          )
        ],
      ),
    );
  }
}
