import 'dart:io';

import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class MyAppTrayListener with TrayListener {
  @override
  void onTrayIconMouseDown() async {

    await TrayManager.instance.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    if (menuItem.key == 'exit_app') {
      exit(0);
    }
    if (menuItem.key == 'show_window') {

      windowManager.show();
    }
  }
}