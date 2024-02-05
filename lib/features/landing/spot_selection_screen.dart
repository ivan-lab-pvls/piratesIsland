import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pirate/features/shared/widgets/back_buttonn.dart';
import 'package:pirate/features/shared/widgets/button.dart';
import 'package:pirate/features/shared/widgets/stroke_title.dart';
import 'package:pirate/router/router.dart';
import 'package:pirate/theme.dart';

@RoutePage()
class SpotSelectionScreen extends StatelessWidget {
  SpotSelectionScreen({super.key});

  final controller = PageController(
    initialPage: 0,
  );

  final customPageController = CustomPageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/main/bg.png'),
          fit: BoxFit.cover,
          opacity: 0.7,
        )),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Stack(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: BackButtonn(isActive: true),
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: PageView(
                      onPageChanged: (value) {
                        customPageController.updatePage(value);
                      },
                      controller: controller,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const StrokeTitle(
                                text: 'ROULETTE', strokeWidth: 2),
                            Image.asset('assets/spots/roulette.png'),
                            const SizedBox(height: 10),
                            Button(
                                child: Text('Play', style: smallTS),
                                callback: (p0) =>
                                    context.router.push(const RouletteRoute())),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const StrokeTitle(
                                text: 'MACHINE', strokeWidth: 2),
                            Image.asset('assets/spots/slot.png'),
                            const SizedBox(height: 10),
                            Button(
                              child: Text('Play', style: smallTS),
                              callback: (p0) =>
                                  context.router.push(const PokiesRoute()),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const StrokeTitle(
                                text: 'TURBO', strokeWidth: 2),
                            Image.asset('assets/spots/pokies.png'),
                            const SizedBox(height: 10),
                            Button(
                              child: Text('Play', style: smallTS),
                              callback: (p0) =>
                                  context.router.push(const SlotRoute()),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                GetBuilder(
                  init: customPageController,
                  builder: (_) {
                    if (customPageController.page != 0) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Button(
                          child: SvgPicture.asset('assets/icons/back.svg'),
                          callback: (p0) => controller.previousPage(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut),
                        ),
                      );
                    } else {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Button(
                          child: SvgPicture.asset('assets/icons/back.svg'),
                        ),
                      );
                    }
                  },
                ),
                GetBuilder(
                  init: customPageController,
                  builder: (_) {
                    if (customPageController.page != 2) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Button(
                          child: Transform.rotate(
                            angle: pi,
                            child: SvgPicture.asset('assets/icons/back.svg'),
                          ),
                          callback: (p0) => controller.nextPage(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut),
                        ),
                      );
                    } else {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Button(
                          child: Transform.rotate(
                            angle: pi,
                            child: SvgPicture.asset('assets/icons/back.svg'),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomPageController extends GetxController {
  int page = 0;
  void updatePage(int value) {
    page = value;
    update();
  }
}
