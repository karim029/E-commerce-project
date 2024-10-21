// manage the navigation state

import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppRoute {
  dashboard,
  loading,
  settings,
  register,
  logIn,
  home,
  verification,
  passwordcode,
  passwordReset,
  passwordChange,
}

class RouteNotifier extends Notifier<AppRoute> {
  // default location
  @override
  AppRoute build() {
    return AppRoute.logIn;
  }

  // method to change state
  void goTo(AppRoute route) {
    state = route;
  }
}

// exposes an instance of the route notifier to the rest of the application
// this provider allows other parts of the app to interact with and observe routes changes

final routeNotifierProvider = NotifierProvider<RouteNotifier, AppRoute>(() {
  return RouteNotifier();
});
