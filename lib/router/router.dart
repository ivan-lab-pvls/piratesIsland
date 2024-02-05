import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../features/landing/main_screen.dart';
import '../features/games/pokies/pokies_screen.dart';
import '../features/games/roulette/roulette_screen.dart';
import '../features/games/slot/slot_screen.dart';
import '../features/landing/gift_screen.dart';
import '../features/landing/spot_selection_screen.dart';
import '../features/settings/privacy_policy_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/settings/terms_of_use_screen.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        CustomRoute(
            page: MainRoute.page,
            initial: true,
            transitionsBuilder: TransitionsBuilders.slideRightWithFade),
        CustomRoute(
            page: SpotSelectionRoute.page,
            transitionsBuilder: TransitionsBuilders.fadeIn),
        CustomRoute(
            page: SlotRoute.page,
            transitionsBuilder: TransitionsBuilders.fadeIn),
        CustomRoute(
            page: PokiesRoute.page,
            transitionsBuilder: TransitionsBuilders.fadeIn),
        CustomRoute(
            page: RouletteRoute.page,
            transitionsBuilder: TransitionsBuilders.fadeIn),
        CustomRoute(
            page: SettingsRoute.page,
            transitionsBuilder: TransitionsBuilders.slideBottom),
        AutoRoute(page: TermsOfUseRoute.page),
        AutoRoute(page: PrivacyPolicyRoute.page),
        AutoRoute(page: GiftRoute.page),
      ];
}
