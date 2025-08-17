import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spin_piece/pages/draw_page.dart';
import 'package:spin_piece/providers/wheel_data_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key _providerKey = UniqueKey();

  void resetProviders() {
    setState(() {
      _providerKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      key: _providerKey,

      create: (context) => WheelDataProvider(),
      child: Builder(
        builder: (context) {
          final mediaQuery = MediaQuery.of(context);
          final updatedMediaQuery = mediaQuery.copyWith(
            textScaler: const TextScaler.linear(1.0),
          );
          return MediaQuery(
            data: updatedMediaQuery,
            child: MaterialApp(
              title: 'Mandhi App',
              theme: ThemeData(
                colorScheme: const ColorScheme(
                  primary: Color(0xFF005BA7),
                  onPrimary: Colors.white,
                  secondary: Color(0xFFDD6D41),
                  onSecondary: Colors.white,
                  tertiary: Color(0xFFF8F4E3),
                  onTertiary: Color(0xFF0a3d2c),
                  surface: Color(0xFFF0F0F0),
                  onSurface: Color(0xFF0A3D2C),
                  error: Color(0xFFB00020),
                  onError: Colors.white,
                  brightness: Brightness.light,
                ),
              ),
              home: DrawPage(onReset: resetProviders),
            ),
          );
        },
      ),
    );
  }
}
