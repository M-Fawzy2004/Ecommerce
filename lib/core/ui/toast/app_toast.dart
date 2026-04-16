import 'package:flutter/material.dart';
import 'toast_type.dart';
import 'toast_widget.dart';

class AppToast {
  AppToast._();

  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 4),
    String? subtitle,
    VoidCallback? onTap,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => ToastWidget(
        message: message,
        subtitle: subtitle,
        type: type,
        duration: duration,
        onTap: onTap,
        onDismiss: () {
          if (overlayEntry.mounted) {
            overlayEntry.remove();
          }
        },
      ),
    );

    overlay.insert(overlayEntry);
  }

  static void success(
    BuildContext context, {
    required String message,
    String? subtitle,
  }) {
    show(
      context,
      message: message,
      subtitle: subtitle,
      type: ToastType.success,
    );
  }

  static void error(
    BuildContext context, {
    required String message,
    String? subtitle,
  }) {
    show(context, message: message, subtitle: subtitle, type: ToastType.error);
  }

  static void info(
    BuildContext context, {
    required String message,
    String? subtitle,
  }) {
    show(context, message: message, subtitle: subtitle, type: ToastType.info);
  }

  static void warning(
    BuildContext context, {
    required String message,
    String? subtitle,
  }) {
    show(
      context,
      message: message,
      subtitle: subtitle,
      type: ToastType.warning,
    );
  }
}
