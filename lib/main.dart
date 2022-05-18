import 'package:eventcounter/pages/home/home_page.dart';
import 'package:eventcounter/controllers/event_group_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(overrides: [
    eventGroupControllerProvider.overrideWithProvider(Provider((ref) {
      final controller = EventGroupController(ref);
      controller.load();
      return controller;
    }))
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EventCounter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'EventCounter'),
    );
  }
}
