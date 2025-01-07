import 'package:casa_inteligente/theme/theme.dart';
import 'package:casa_inteligente/theme/util.dart';
import 'package:casa_inteligente/ui/widgets/auth_checker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'core/providers.dart';
import 'firebase_options.dart';

// Configuração para notificações locais
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Função que será chamada quando uma notificação for recebida enquanto o app estiver em segundo plano
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  await _showNotification(message);
}

Future<void> _showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'sensor_channel', // ID do canal
    'Sensor de Presença', // Nome do canal
    channelDescription: 'Notificações do sensor de presença',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );

  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0, // ID da notificação
    message.notification?.title ?? 'Movimento Detectado', // Título
    message.notification?.body ?? 'O sensor de presença detectou movimento.', // Corpo
    platformChannelSpecifics,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicialização do Flutter Local Notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Inicialize o Firebase Messaging
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Solicita permissões para notificações (somente no iOS)
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission();
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print("Permissão para notificações concedida!");
  } else {
    print("Permissão para notificações não concedida!");
  }

  final data = await ConfigureProviders.createDependencyTree();

  runApp(AppRoot(data: data));
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key, required this.data});

  final ConfigureProviders data;

  void _initializeFirebaseDatabaseListener() {
    // Referência ao nó do sensor de presença
    final DatabaseReference presenceRef =
    FirebaseDatabase.instance.ref('Casa/sala/presenca');

    // Escutar mudanças no valor de presença
    presenceRef.onValue.listen((DatabaseEvent event) {
      final presence = event.snapshot.value as bool?;

      // Verifica se o valor de presença é true
      if (presence == true) {
        _showNotification();
      }
    });
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'sensor_channel', // ID do canal
      'Sensor de Presença', // Nome do canal
      channelDescription: 'Notificações do sensor de presença',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // ID da notificação
      'Movimento Detectado', // Título
      'O sensor de presença na sala detectou movimento.', // Corpo
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {

    _initializeFirebaseDatabaseListener();

    TextTheme textTheme = createTextTheme(context, "Roboto Flex", "Roboto");

    MaterialTheme theme = MaterialTheme(textTheme);

    return MultiProvider(
      providers: data.providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Casa Inteligente',
        theme: theme.light(),
        darkTheme: theme.dark(),
        home: const AuthChecker(),
      ),
    );
  }
}
