// work_screen.dart
import 'package:flutter/material.dart';

class WorkScreen extends StatelessWidget {
  const WorkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WorkManager')),
      body: Center(
        child: Text(
          'Se ha registrado una tarea periódica que se ejecuta cada 15 minutos.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}