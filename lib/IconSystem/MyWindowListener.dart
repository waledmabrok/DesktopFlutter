import 'package:window_manager/window_manager.dart';

class MyWindowListener with WindowListener {
  @override
  void onWindowClose() async {
    final preventClose = await windowManager.isPreventClose();
    if (preventClose) {
      await windowManager.hide();
    } else {
      await windowManager.destroy();
    }
  }
}