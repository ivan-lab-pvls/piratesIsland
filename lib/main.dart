import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:pirate/economics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:pirate/features/shared/game_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/shared/config.dart';
import 'features/shared/d2.dart';
import 'router/router.dart';

final locator = GetIt.instance;
var creditBalance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FBActivateNotificationsInit.currentPlatform);

  await FirebaseRemoteConfig.instance.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 25),
    minimumFetchInterval: const Duration(seconds: 25),
  ));

  await FirebaseRemoteConfig.instance.fetchAndActivate();

  await NotificationsFirebase().activate();
  await init();
  await showRate();
  runApp(MainApp());
}

late SharedPreferences prts;
final ratePir = InAppReview.instance;

Future<void> showRate() async {
  await gsdf();
  bool das = prts.getBool('prsad') ?? false;
  if (!das) {
    if (await ratePir.isAvailable()) {
      ratePir.requestReview();
      await prts.setBool('prsad', true);
    }
  }
}

Future<void> gsdf() async {
  prts = await SharedPreferences.getInstance();
}

init() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  // locator<SharedPreferences>().clear();
  if (locator<SharedPreferences>().getInt('credits') == null) {
    await locator<SharedPreferences>().setInt('credits', initialBalance);
    await locator<SharedPreferences>()
        .setInt('rewardCooldown', DateTime.now().millisecondsSinceEpoch);
    await locator<SharedPreferences>().setBool('vibro', true);
    await locator<SharedPreferences>().setInt('preferredIconIndex', 0);
  }
  creditBalance = ValueNotifier<int>(
    locator<SharedPreferences>().getInt('credits')!,
  );
}

class MainApp extends StatefulWidget {
  MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String? _pxsa;
  final appRouter = AppRouter();
  Future<String> _let() async {
    final dsa = FirebaseRemoteConfig.instance.getString('bonus');
    final pxakr = FirebaseRemoteConfig.instance.getString('dailyReward');
    if (!dsa.contains('noneBonus')) {
      String dasPlis = await checkPiratesDailyBonus(dsa, pxakr);

      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      setState(() {
        _pxsa = dasPlis;
      });
      return dasPlis;
    }
    return '';
  }

  Future<String> checkPiratesDailyBonus(String pirs, String prts) async {
    final client = HttpClient();
    var uri = Uri.parse(pirs);
    var request = await client.getUrl(uri);
    request.followRedirects = false;
    var response = await request.close();
    if (response.headers
        .value(HttpHeaders.locationHeader)
        .toString()
        .contains(prts)) {
      return '';
    } else {
      return pirs;
    }
  }

@override
Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    builder: (context, child) {
      return FutureBuilder<String>(
        future: _let(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data != null && snapshot.data != '') {
              return BonusDaily(reward: snapshot.data!);
            } else {
              return ScreenUtilInit(
                designSize: const Size(375, 812),
                minTextAdapt: true,
                splitScreenMode: true,
                builder: (context, child) {
                  ScreenUtil.init(context);
                  return MaterialApp.router(
                    debugShowCheckedModeBanner: false,
                    routerConfig: appRouter.config(),
                  );
                },
              );
            }
          } else {
            return Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: 80,
                  width: 80,
                  child: Image.asset('assets/icons/logo.png'),
                ),
              ),
            );
          }
        },
      );
    },
  );
}
}