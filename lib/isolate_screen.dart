import 'dart:isolate';
import 'package:flutter/material.dart';

class IsolateScreen extends StatefulWidget {
  const IsolateScreen({super.key});

  @override
  _IsolateScreenState createState() => _IsolateScreenState();
}

class _IsolateScreenState extends State<IsolateScreen> {
  int counter = 0;
  Isolate? _isolate;
  ReceivePort? _receivePort;

  void startIsolate() async {
    if (_isolate != null) return; // Evita múltiples isolations

    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(countIsolate, _receivePort!.sendPort);

    _receivePort!.listen((message) {
      setState(() {
        counter = message;
      });
    });
  }

  void stopIsolate() {
    _receivePort?.close();
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _receivePort = null;
  }

  static void countIsolate(SendPort sendPort) async {
    int count = 0;
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      count++;
      sendPort.send(count);
    }
  }

  @override
  void dispose() {
    stopIsolate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Isolate: Contador')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Contador: $counter', style: TextStyle(fontSize: 28)),
            SizedBox(height: 20),
            ElevatedButton(onPressed: startIsolate, child: Text('Iniciar')),
            ElevatedButton(onPressed: stopIsolate, child: Text('Detener')),
          ],
        ),
      ),
    );
  }
}
