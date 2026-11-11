import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'notifiche_source.dart';

class NotificheLocaliSourceImpl implements NotificheSource {
 NotificheLocaliSourceImpl({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();
      final FlutterLocalNotificationsPlugin _plugin;
 
 @override
 Future<void> inizializza({void Function(String? payload) ?  onTap}) async {
  tzdata.initializeTimeZones();
  final fuso = await FlutterTimezone.getLocalTimezone();
  
    tz.setLocalLocation(tz.getLocation(fuso.identifier));
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const ios = DarwinInitializationSettings();
  await _plugin.initialize(
    settings: const InitializationSettings(android: android, iOS: ios),
  onDidReceiveNotificationResponse:  (response) => onTap?.call(response.payload),
  );
  await _plugin.
  resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
  ?.createNotificationChannel(const AndroidNotificationChannel(
      'promemoria', 'Promemoria', description: 'Avvisi del promemoria', importance: Importance.max,
  ));
 }
    @override
    Future<bool> permessoConcesso() async {
      final android = _plugin.
      resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      final androidGranted = await android?.areNotificationsEnabled();
      if (androidGranted != null) return androidGranted;
      final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      final settings = await ios?.checkPermissions();
      return settings?.isEnabled ?? true;
    }

    @override
    Future<bool> chiediPermesso() async {
      final android = _plugin.
      resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      final androidGranted = await android?.requestNotificationsPermission();
      if (androidGranted != null) return androidGranted;
      final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      final iosGranted = await ios?.requestPermissions(alert: true, badge: true, sound: true);
      return iosGranted ?? true;
    }

    @override
    Future<void> programma({required int id, required DateTime quando, required String titolo}) async {
       await _plugin.zonedSchedule(
        id: id, title: 'Promemoria', body: titolo, 
        scheduledDate: tz.TZDateTime.from( quando, tz.local),
     
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails('promemoria', 'Promemoria', channelDescription: 'Avvisi dei promemoria', importance: Importance.max, priority: Priority.high),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: '$id',
       );
    }

    @override
    Future<void> cancella(int id) => _plugin.cancel(id: id);

    @override
    Future<List<int>> idInCoda() async =>
        (await _plugin.pendingNotificationRequests()).map((e) => e.id).toList();
}