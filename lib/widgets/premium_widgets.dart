import 'package:flutter/material.dart';
import '../theme.dart';

class PremiumToast {
  static void show(
    BuildContext context,
    String message, {
    bool isError = false,
    bool isWarning = false,
  }) {
    Color bg = AppColors.buttonDark;
    IconData icon = Icons.info_outline_rounded;
    Color iconColor = Colors.white;

    if (isError) {
      bg = const Color(0xFFFEE2E2);
      icon = Icons.error_outline_rounded;
      iconColor = const Color(0xFFEF4444);
    } else if (isWarning) {
      bg = const Color(0xFFFEF3C7);
      icon = Icons.warning_amber_rounded;
      iconColor = const Color(0xFFD97706);
    } else {
      bg = const Color(0xFFECFDF5);
      icon = Icons.check_circle_outline_rounded;
      iconColor = const Color(0xFF10B981);
    }

    final textColor = isError
        ? const Color(0xFF991B1B)
        : (isWarning ? const Color(0xFF92400E) : const Color(0xFF065F46));

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: bg,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        content: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

class PremiumDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final List<Widget>? actions;

  const PremiumDialog({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
    this.actions,
  });

  static void show(
    BuildContext context, {
    required String title,
    required String message,
    IconData icon = Icons.info_outline_rounded,
    Color iconColor = AppColors.primary,
    List<Widget>? actions,
  }) {
    showDialog(
      context: context,
      builder: (context) => PremiumDialog(
        title: title,
        message: message,
        icon: icon,
        iconColor: iconColor,
        actions: actions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Accent Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 36),
            ),
            const SizedBox(height: 20),
            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            // Body Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 24),
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions ??
                  [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonDark,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        minimumSize: Size.zero,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Got it", style: TextStyle(fontSize: 12)),
                    )
                  ],
            ),
          ],
        ),
      ),
    );
  }
}
