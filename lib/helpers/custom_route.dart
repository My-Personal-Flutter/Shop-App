import 'package:flutter/material.dart';

class CustomRoute<T> extends MaterialPageRoute<T> {
  // For using at single level

  // For single route on the fly creation
  CustomRoute({
    WidgetBuilder? widgetBuilder,
    RouteSettings? routeSettings,
  }) : super(
          builder: widgetBuilder!,
          settings: routeSettings,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.name == '/') {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  // For using at multi level

  // For general theme
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    if (route.settings.name == '/') {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
