import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FlowUtil {
  static Route<T> createRoute<T>(
    FlowTransition transition, {
    required Widget page,
    String? name,
    Duration? transitionDuration,
  }) {
    switch (transition) {
      case FlowTransition.cupertino:
        return cupertinoRoute(page: page, name: name);
      case FlowTransition.material:
        return materialRoute(page: page, name: name);
      case FlowTransition.fade:
        return fadeRoute(
          page: page,
          name: name,
          transitionDuration: transitionDuration,
        );
      case FlowTransition.slide:
        return slideRoute(
          page: page,
          name: name,
          transitionDuration: transitionDuration,
        );
    }
  }

  static Route<T> cupertinoRoute<T>({required Widget page, String? name}) {
    return CupertinoPageRoute(
      settings: RouteSettings(name: name),
      builder: (context) => page,
    );
  }

  static Route<T> materialRoute<T>({required Widget page, String? name}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: name),
      builder: (context) => page,
    );
  }

  static Route<T> slideRoute<T>({
    required Widget page,
    String? name,
    Duration? transitionDuration,
  }) {
    return PageRouteBuilder<T>(
      settings: RouteSettings(name: name),
      transitionDuration: transitionDuration ?? 300.ms,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static Route<T> fadeRoute<T>({
    required Widget page,
    String? name,
    Duration? transitionDuration,
  }) {
    return PageRouteBuilder<T>(
      settings: RouteSettings(name: name),
      transitionDuration: transitionDuration ?? 300.ms,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.ease;

        final tween = Tween<double>(begin: begin, end: end)
            .chain(CurveTween(curve: curve));

        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static Future<T?> moveToAndReplace<T extends Object, TO extends Object>({
    required BuildContext context,
    required Widget page,
    String? name,
    FlowTransition transition = FlowTransition.cupertino,
    Duration? transitionDuration,
  }) {
    return Navigator.of(context).pushReplacement(
      FlowUtil.createRoute<T>(
        transition,
        page: page,
        name: name,
        transitionDuration: transitionDuration,
      ),
    );
  }

  static Future<T?> moveToAndRemoveAll<T extends Object>({
    required BuildContext context,
    required Widget page,
    String? name,
    FlowTransition transition = FlowTransition.cupertino,
    Duration? transitionDuration,
  }) {
    return Navigator.of(context).pushAndRemoveUntil(
      FlowUtil.createRoute<T>(
        transition,
        page: page,
        name: name,
        transitionDuration: transitionDuration,
      ),
      (route) => false,
    );
  }

  static Future<T?> moveTo<T extends Object>({
    required BuildContext context,
    required Widget page,
    String? name,
    FlowTransition transition = FlowTransition.cupertino,
    Duration? transitionDuration,
  }) {
    return Navigator.of(context).push(
      FlowUtil.createRoute<T>(
        transition,
        page: page,
        name: name,
        transitionDuration: transitionDuration,
      ),
    );
  }

  static void back<T extends Object>({
    required BuildContext context,
    T? result,
  }) {
    Navigator.pop<T>(context, result);
  }

  static void backTo(BuildContext context, RoutePredicate predicate) {
    Navigator.of(context).popUntil(predicate);
  }

  static void moveToAndRemoveUtil(
      BuildContext context, Widget newPage, String pageName) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => newPage),
        ModalRoute.withName(pageName));
  }
}

enum FlowTransition { cupertino, material, fade, slide }
