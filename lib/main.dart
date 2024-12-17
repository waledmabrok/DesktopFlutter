import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';  // تأكد من استيراد الحزم اللازمة
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'package:yourcolor_project/Login/Login.dart';

import 'IconSystem/MyAppTrayListener.dart';
import 'IconSystem/MyWindowListener.dart';

void main() async {
  runApp(QRCodeServerApp());
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    // Tray menu setup
    await TrayManager.instance.setIcon('assets/app_icon.ico');

    Menu menu = Menu(
      items: [
        MenuItem(
          key: 'show_window',
          label: 'عرض النافذة',
        ),
        MenuItem.separator(),
        MenuItem(
          key: 'exit_app',
          label: 'خروج من التطبيق',
        ),
      ],
    );

    await TrayManager.instance.setContextMenu(menu);

    TrayManager.instance.addListener(MyAppTrayListener());
    await windowManager.setPreventClose(true);
    windowManager.addListener(MyWindowListener());
  }
}

class QRCodeServerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      // إضافة دعم اللغة العربية
      locale: Locale('ar', 'AE'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ar', 'AE'),
      ],
     
    );
  }
}
