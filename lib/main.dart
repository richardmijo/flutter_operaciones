// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_operaciones/background_screen.dart';
import 'package:flutter_operaciones/isolate_screen.dart';
import 'package:flutter_operaciones/work_screen.dart';

import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterBackground.initialize(
    androidConfig: FlutterBackgroundAndroidConfig(
      notificationTitle: 'Segundo plano activo',
      notificationText: 'La app sigue funcionando.',
      notificationImportance: AndroidNotificationImportance.high,
      enableWifiLock: true,
    ),
  );

  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  runApp(MyApp());
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint("[WorkManager] Tarea ejecutada: \$task");
    return Future.value(true);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Background Demo',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Demo: Isolate, Background, WorkManager')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Isolate: Contador'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => IsolateScreen()));
              },
            ),
            ElevatedButton(
              child: Text('WorkManager: Tarea periódica'),
              onPressed: () async {
                await Workmanager().registerPeriodicTask(
                  "periodicTask",
                  "simpleTask",
                  frequency: Duration(minutes:  15),
                );
                Navigator.push(context, MaterialPageRoute(builder: (_) => WorkScreen()));
              },
            ),
            ElevatedButton(
              child: Text('Background: Permiso y notificación'),
              onPressed: () async {
                final hasPermission = await FlutterBackground.hasPermissions;
                if (!hasPermission) {
                  final success = await FlutterBackground.enableBackgroundExecution();
                  if (!success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No se otorgaron permisos')),
                    );
                    return;
                  }
                }
                Navigator.push(context, MaterialPageRoute(builder: (_) => BackgroundScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}





