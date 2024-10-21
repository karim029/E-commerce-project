import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class ThemeNotifier extends Notifier<bool> {
  @override
  bool build() {
    final box = Hive.box<bool>('themeMode');
    final isdark = box.get('themedark', defaultValue: false);
    return isdark!;
  }

  void enableDarkMode(bool isEnabled) {
    final box = Hive.box<bool>('themeMode');
    box.put('themedark', isEnabled);
    state = isEnabled;
  }
}

final themeNotifierProvider = NotifierProvider<ThemeNotifier, bool>(
  () => ThemeNotifier(),
);
