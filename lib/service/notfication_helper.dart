import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habit_track/feature/home/data/notification_firebase_operation.dart';
import 'package:habit_track/service/cash_helper.dart';
import 'package:habit_track/service/const_varible.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  //init notfication

  static Future<void> initFirebaseMessaging() async {
    isNotificationEnabled =
        await CashNetwork.GetFromCash(key: 'isNotificationEnabled');
    log(isNotificationEnabled.toString());
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationFirebaseOperation notficationfirebase =
        NotificationFirebaseOperation();
    // Initialize flutter local notifications
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Check if notification permission is already granted
    PermissionStatus permissionStatus = await Permission.notification.status;
    if (!permissionStatus.isGranted) {
      permissionStatus = await Permission.notification.request();
      if (permissionStatus.isGranted) {
        log('User granted notification permission.');
      } else {
        log('User denied notification permission.');
      }
    } else {
      log('Notification permission already granted.');
    }

    // Get the FCM token to send notifications to this device
    token = await messaging.getToken();
    log('FCM Token: $token');

    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        await notficationfirebase.setNotfication(
            massageText: message.notification!.body!);
        // Display local notification when the app is in the foreground
        if (message.notification != null) {
          await _showLocalNotification(
            flutterLocalNotificationsPlugin,
            message.notification!.title,
            message.notification!.body,
          );
        }
      },
    );

    // Handle background notifications (when the app is opened by clicking a notification)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      log('Notification clicked and app opened: ${message.notification?.title}');
      await notficationfirebase.setNotfication(
          massageText: message.notification!.body!);
    });
  }

  //handel local notfication
  static Future<void> _showLocalNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    String? title,
    String? body,
  ) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title, // Notification Title
      body, // Notification Body
      platformChannelSpecifics,
    );
  }

//get accsess token
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "habit-track-6d4ba",
      "private_key_id": "216543c60f68eb709101ae0d5ab5d8ad4c6f58c1",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDZYEW12g762Sv/\nO3AJIVsD22ynEJP4Q4OW0cjnqC+nd/Y3KnNlTVAj8W5eXRqBizQgDePB9fGLCKKf\ntYCq8vA8KImlAdsX6ZbCc5rIHXviw+i0x/OMiFTPZaPjhFdMu2Im4BYMGMqJ6eSr\nOgcCtS6JBRF3MgZcww2qO6BNr6V8/BrRJwZ2SpEiWoNQB5CHOPodkjC7a+LZ/jeC\nYJnhqfLHiUaUHkzOdwlgSLmyDpZ1Ls4UlKdVqYPAK5ygb2hhBjQN8r+ZTczeoLpE\nfdwWHnbyfqD8cnZSBTNSjBhnf4AcxZv+bU2myDKnbnwifJUgjEUcA5KhOzOjxEAH\nR971rzL/AgMBAAECggEAIxh1CNBE/OEVRmb9RqwY+r1xhGOb0EhuNWp3aldwIjSv\nDucOrHtYBgWT0S5s+h9Uchxr+kPQFKd3QhvWw0Ln4H6XAooTKoAvNAPgKJECEHGa\n350syDK2pql9VV1njt7uEOK7DIbwJGYb4j1DJn/EHKEx2bG87zsauLJZxlEmgdAR\n399GU4UkHBC4Sru9Du/HMR2d0TCuiNRrYpNrTJcHB/BqBBgCvu0Yb+li+0THBbDF\n0kQEp+7mSLUH1+heVy1vS8vnqqBOdzoiL5jPaJrvEKqSvMmvTs7+wkmEIVT/bCmA\nq4RgLHplRdW1tLbFp1AvwwRxaJQkfqfAse1v7VK78QKBgQD6skl58+CLD4IUD/om\n2P4PDXtX1faLG8krbOTZPwMxu61j7glxesNvJLSAovSxNLi1GPFdt3fZn02gaBal\nslj3OWXvK7pQpya/hdwiHhQ/hz0+bmWwwGgRf3JikvT5KndOKYPKnCl+FN3817gl\nv07u/Tbn1D+djYKggI/9coz1CQKBgQDd+Yetr063oXNqKI8Zb5hUT4gHpPftFQR7\n6P6rwWT6mvtQmX/x1EYjfKRKXcM/p5UaMRZCxappwcBuP9eCKsZXAL+J1yL0i9oL\nisJdS23t4MBxmFJ/WFB4h7p+3Uveq9RkmRpLixP0/xOLc5iDdYSvAVmc6aPCV92F\n1vGD6QYxxwKBgQDQEk29tFZ31KVH9YLP32XuJGhtHJ8GEkfDjRvb29rQ2k4tFJIt\n55BxnOtboOSqd3GejVc3S2Fj9D4/lmTFneMNPkyGV6rJ6hHVAEsW3hQ8Lgj82i/4\npZk6fKb5fbNpYn+nFfnWngoqJTOh+YFTgxcGcI+zlow+PgdfI5Ve7EZl0QKBgQDL\n/VvdloSNpraM8XcIVhC0Ml59P/KDktQLF0SrDNBCqZiZKmd1ErHePNYybVZYMiaI\n6mFdvY9tHxw7dToUqkCZhdt/zhCWkcsw3jTeTcpZWDkia2wtETjqezk9CxuFJ33J\ncRXEJKyTcrJAblvTO3VS6reyxteyatLuA2jx43zI0wKBgHxE4ql7ykXAca0zrHbJ\n8hA5TraNBguEOOtGxKW7d6fnL+G+COqz4hFCtkW8sT52Fib9OjwDDjKH7SrdfQkA\nw3ZZwORoi+0wICeAbkgCy50DKsAYnCxEBwVhHJ2acBgMQ+ViGidhseNV+hRXwkwO\nG7dqF35LV12hn57+D1L8hhqk\n-----END PRIVATE KEY-----\n",
      "client_email": "notifcation@habit-track-6d4ba.iam.gserviceaccount.com",
      "client_id": "102417540832199525698",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/notifcation%40habit-track-6d4ba.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };
    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];
    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);
    client.close();
    return credentials.accessToken.data;
  }

  static Future<void> sendNotification(
      String deviceToken, String title, String body) async {
    String? accessToken;
    try {
      accessToken = await getAccessToken();
    } on Exception catch (e) {
      log(e.toString());
    }
    String endpointFCM =
        'https://fcm.googleapis.com/v1/projects/habit-track-6d4ba/messages:send';
    final Map<String, dynamic> message = {
      "message": {
        "token": deviceToken,
        "notification": {"title": title, "body": body},
        "data": {
          "route": "serviceScreen",
        }
      }
    };

    final http.Response response = await http.post(
      Uri.parse(endpointFCM),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      log('Notification sent successfully');
    } else {
      log('Failed to send notification');
    }
  }
}
