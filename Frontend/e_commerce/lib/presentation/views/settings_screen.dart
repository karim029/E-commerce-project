import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_commerce/providers/route_provider.dart';
import 'package:e_commerce/providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        title: Text('Settings'),
        leading: IconButton(
          onPressed: () {
            ref.read(routeNotifierProvider.notifier).goTo(AppRoute.dashboard);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'General',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              Row(
                children: [
                  Text(
                    'choose Currency',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Spacer(),
                  //Expanded(
                  //  child: CurrencyDropdown(),
                  //),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  const Text('Select Mode'),
                  Spacer(),
                  Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      ref
                          .read(themeNotifierProvider.notifier)
                          .enableDarkMode(value);
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
