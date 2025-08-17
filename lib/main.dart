import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'pages/login_screen.dart';
import 'pages/desktop_drive.dart';
import 'pages/mobile_drive.dart';

void main() {
  runApp(const BockDriveApp());
}

class BockDriveApp extends StatelessWidget {
  const BockDriveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BockDrive',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6A1B9A), // Purple theme to match login screen
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const LoginScreen(), // Show login screen first!
      debugShowCheckedModeBanner: false,
    );
  }
}

// This will be used AFTER login to show the appropriate drive screen
class ResponsiveDriveHome extends StatelessWidget {
  const ResponsiveDriveHome({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use desktop version for desktop/tablet (width > 768) or when running on web
        if (constraints.maxWidth > 768 || kIsWeb) {
          return const DesktopDrive();
        } else {
          // Use mobile version for mobile devices
          return const MobileDrive();
        }
      },
    );
  }
}