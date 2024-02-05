import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:pirate/features/shared/widgets/stroke_title.dart';
import 'package:pirate/main.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

import '../../router/router.dart';
import '../../theme.dart';
import '../shared/widgets/back_buttonn.dart';

final settingsController = SettingsController();

@RoutePage()
class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    settingsController.getVibro();
    settingsController.getAppIconIndex();

    return Scaffold(
      body: Container(
        color: blueColor1,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Stack(children: [
              Align(
                alignment: Alignment.topLeft,
                child: Transform.rotate(
                  angle: pi / 2,
                  child: const BackButtonn(isActive: true),
                ),
              ),
              const Align(
                alignment: Alignment.topCenter,
                child: StrokeTitle(text: 'SETTINGS'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Builder(builder: (_) {
                        return SettingsItem(
                            child: Text('Share with friends', style: smallTS),
                            callback: (p0) {
                              final box = _.findRenderObject() as RenderBox?;
                              Share.share('Check out this pirate game!',
                                  sharePositionOrigin:
                                      box!.localToGlobal(Offset.zero) &
                                          box.size);
                            });
                      }),
                      const SizedBox(height: 10),
                      SettingsItem(
                          child: Text('Privacy policy', style: smallTS),
                          callback: (p0) =>
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Pirates(
                                    prts:
                                        'https://docs.google.com/document/d/14bwY8Etb-2QhyAqbXf0HG0EpYd36NmurgIcKrRxQoDc/edit?usp=sharing'),
                              ))),
                      const SizedBox(height: 10),
                      SettingsItem(
                          child: Text('Terms of use', style: smallTS),
                          callback: (p0) =>
                               Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Pirates(
                                    prts:
                                        'https://docs.google.com/document/d/1pwNPvMGV2a3PED8XARQshxeW6GNBhQV-2iZktstJS88/edit?usp=sharing'),
                              ))),
                    ],
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text('Vibro', style: smallTS),
                            GetBuilder(
                                init: settingsController,
                                builder: (_) {
                                  if (settingsController.vibro != null) {
                                    return CupertinoSwitch(
                                        activeColor: blueColor2,
                                        value: settingsController.vibro,
                                        onChanged: (value) {
                                          settingsController.toggleVibro();
                                          if (settingsController.vibro) {
                                            Vibration.vibrate();
                                          }
                                        });
                                  } else {
                                    return const CupertinoActivityIndicator();
                                  }
                                })
                          ],
                        ),
                       ],
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  changeAppIcon(int index) async {
    try {
      if (await FlutterDynamicIcon.supportsAlternateIcons) {
        await FlutterDynamicIcon.setAlternateIconName('icon${index + 1}');
        settingsController.changeAppIcon(index);
        return;
      }
    } catch (e) {
      // print(e);
    }
  }
}

class SettingsItem extends StatelessWidget {
  final Widget child;
  final Function(dynamic) callback;
  const SettingsItem({
    super.key,
    required this.child,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => callback('Argument'),
      child: Container(
        width: MediaQuery.of(context).size.width / 4,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            color: blueColor2,
            border: Border.all(width: 4, color: blueColor3)),
        child: Center(child: child),
      ),
    );
  }
}

class SettingsController extends GetxController {
  var vibro;
  var appIconIndex;
  void getVibro() {
    vibro = locator<SharedPreferences>().getBool('vibro');
    update();
  }

  void getAppIconIndex() {
    appIconIndex = locator<SharedPreferences>().getInt('preferredIconIndex');
    update();
  }

  Future<void> toggleVibro() async {
    vibro = !vibro;
    await locator<SharedPreferences>().setBool('vibro', vibro);
    update();
  }

  Future<void> changeAppIcon(int index) async {
    appIconIndex = index;
    await locator<SharedPreferences>()
        .setInt('preferredIconIndex', appIconIndex);
    update();
  }
}

class Pirates extends StatefulWidget {
  const Pirates({super.key, required this.prts});
  final String prts;

  @override
  State<Pirates> createState() => _PiratesState();
}

class _PiratesState extends State<Pirates> {
  var _progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            InAppWebView(
              onLoadStop: (controller, url) {
                controller.evaluateJavascript(
                    source:
                        "javascript:(function() { var ele=document.getElementsByClassName('docs-ml-header-item docs-ml-header-drive-link');ele[0].parentNode.removeChild(ele[0]);var footer = document.getelementsbytagname('footer')[0];footer.parentnode.removechild(footer);})()");
              },
              onProgressChanged: (controller, progress) => setState(() {
                _progress = progress;
              }),
              initialUrlRequest: URLRequest(
                url: Uri.parse(widget.prts),
              ),
            ),
            if (_progress != 100)
              Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
