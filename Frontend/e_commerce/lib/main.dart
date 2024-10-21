import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:e_commerce/routing/app_router.dart';
import 'package:e_commerce/providers/theme_provider.dart';
import 'package:e_commerce/core/theme.dart';
import 'package:e_commerce/model/theme_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ThemeModelAdapter());
  await Hive.openBox<bool>('themeMode');

  runApp(
    ProviderScope(
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    final isDarkMode = ref.watch(themeNotifierProvider);
    return MaterialApp.router(
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? darkAppTheme : lightAppTheme,
    );
  }
}
