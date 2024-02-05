import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pirate/features/shared/widgets/stroke_title.dart';
import 'package:pirate/theme.dart';

import '../shared/widgets/back_buttonn.dart';

@RoutePage()
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: blueColor1,
        child: const SafeArea(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Stack(children: [
              Align(
                alignment: Alignment.topLeft,
                child: BackButtonn(isActive: true),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: StrokeTitle(text: 'PRIVACY POLICY'),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
