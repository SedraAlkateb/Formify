import 'package:flutter/material.dart';
import 'package:formify/presentation/resources/strings_manager.dart';
class Routes {
  static const String login = "/login";

}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
     switch (settings.name) {
       case Routes.login:
     // initLoginModule();
        //
        // return MaterialPageRoute(builder: (_) => MyLogin());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text(
                    StringsManager.noRouteFound), // string to strings manager
              ),
              body: const Center(
                  child: Text(
                      StringsManager.noRouteFound)), //string to strings manager
            ));
  }
}
