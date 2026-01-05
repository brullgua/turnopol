import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnopol/pages/root_page.dart';
import 'core/theme.dart';
import 'providers/root_provider.dart';
import 'hive/hive_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.initHive();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(lazy: false, create: (_) => RootProvider()),
      ],
      child: const TurnopolApp(),
    ),
  );
}

class TurnopolApp extends StatelessWidget {
  const TurnopolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeColors.themeData,
      themeMode: ThemeMode.dark,
      home: const RootPage()
    );
  }
}
