import 'package:firebase_messaging/firebase_messaging.dart';

import 'd1.dart';

class NotificationsFirebase {
  late final FirebaseMessaging _messaging;

  PushNotification? _notificationInfo;
  final localNoticeService = LocalNotifyService();

  activate() {
    registerNotification();
    checkForInitialMessage();
    listen();
  }

  void registerNotification() async {
    _messaging = FirebaseMessaging.instance;
    localNoticeService.setup();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print(
            'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');

        _notificationInfo = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );

        if (_notificationInfo != null) {
          localNoticeService.addNotification(
            _notificationInfo!.title ?? '',
            _notificationInfo!.body ?? '',
          );
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  checkForInitialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _notificationInfo = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
        dataTitle: initialMessage.data['title'],
        dataBody: initialMessage.data['body'],
      );
    }
  }

  listen() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _notificationInfo = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );
    });
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }
}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
    this.dataTitle,
    this.dataBody,
  });

  String? title;
  String? body;
  String? dataTitle;
  String? dataBody;
}
