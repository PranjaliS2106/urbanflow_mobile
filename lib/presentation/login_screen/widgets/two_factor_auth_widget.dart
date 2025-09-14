import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Two-factor authentication modal widget
class TwoFactorAuthWidget extends StatefulWidget {
  const TwoFactorAuthWidget({
    super.key,
    required this.onCodeSubmit,
    required this.onResendCode,
    required this.isLoading,
  });

  final Function(String code) onCodeSubmit;
  final VoidCallback onResendCode;
  final bool isLoading;

  @override
  State<TwoFactorAuthWidget> createState() => _TwoFactorAuthWidgetState();
}

class _TwoFactorAuthWidgetState extends State<TwoFactorAuthWidget> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _resendCountdown = 0;

  @override
  void initState() {
    super.initState();
    _startResendCountdown();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startResendCountdown() {
    setState(() {
      _resendCountdown = 30;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _resendCountdown--;
        });
        return _resendCountdown > 0;
      }
      return false;
    });
  }

  void _onCodeChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    // Check if all fields are filled
    final code = _controllers.map((c) => c.text).join();
    if (code.length == 6) {
      widget.onCodeSubmit(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(4.w),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(1.w),
            ),
          ),

          SizedBox(height: 3.h),

          // Security Icon
          Container(
            width: 16.w,
            height: 16.w,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'security',
                color: colorScheme.primary,
                size: 8.w,
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Title
          Text(
            'Two-Factor Authentication',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 1.h),

          // Description
          Text(
            'Enter the 6-digit code sent to your registered device',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 12.sp,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 4.h),

          // Code Input Fields
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
                6, (index) => _buildCodeField(index, theme, colorScheme)),
          ),

          SizedBox(height: 4.h),

          // Resend Code Button
          TextButton(
            onPressed: _resendCountdown > 0 || widget.isLoading
                ? null
                : () {
                    widget.onResendCode();
                    _startResendCountdown();
                  },
            child: Text(
              _resendCountdown > 0
                  ? 'Resend code in ${_resendCountdown}s'
                  : 'Resend Code',
              style: theme.textTheme.labelMedium?.copyWith(
                fontSize: 12.sp,
                color: _resendCountdown > 0
                    ? colorScheme.onSurface.withValues(alpha: 0.5)
                    : colorScheme.primary,
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Loading Indicator
          if (widget.isLoading) ...[
            SizedBox(
              width: 6.w,
              height: 6.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              ),
            ),
            SizedBox(height: 2.h),
          ],

          // Safe area padding
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildCodeField(int index, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(
        border: Border.all(
          color: _controllers[index].text.isNotEmpty
              ? colorScheme.primary
              : colorScheme.outline.withValues(alpha: 0.3),
          width: _controllers[index].text.isNotEmpty ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(2.w),
        color: colorScheme.surface,
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        enabled: !widget.isLoading,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) => _onCodeChanged(value, index),
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
        ),
        style: theme.textTheme.headlineSmall?.copyWith(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}
