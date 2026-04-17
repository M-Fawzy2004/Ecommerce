import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Reusable wrapper widget that implements double-back-to-exit functionality.
///
/// Behavior:
/// - If the router can pop (page was pushed), allows normal back navigation.
/// - If the router cannot pop (root page via context.go), requires a
///   double-back press within 2 seconds to exit the app.
class DoubleBackToExitWrapper extends StatefulWidget {
  final Widget child;

  const DoubleBackToExitWrapper({super.key, required this.child});

  @override
  State<DoubleBackToExitWrapper> createState() =>
      _DoubleBackToExitWrapperState();
}

class _DoubleBackToExitWrapperState extends State<DoubleBackToExitWrapper> {
  DateTime? _lastBackPressed;

  Future<bool> _onWillPop() async {
    final now = DateTime.now();

    if (_lastBackPressed != null &&
        now.difference(_lastBackPressed!) < const Duration(seconds: 2)) {
      SystemNavigator.pop();
      return true;
    }

    _lastBackPressed = now;

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          content: Text(
            'general.double_back_exit'.tr(),
            style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final canPop = GoRouter.of(context).canPop();

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop && !canPop) {
          await _onWillPop();
        }
      },
      child: widget.child,
    );
  }
}
