import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Login form widget containing employee ID and password fields
class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({
    super.key,
    required this.employeeIdController,
    required this.passwordController,
    required this.onEmployeeIdChanged,
    required this.onPasswordChanged,
    required this.employeeIdError,
    required this.passwordError,
    required this.isLoading,
  });

  final TextEditingController employeeIdController;
  final TextEditingController passwordController;
  final Function(String) onEmployeeIdChanged;
  final Function(String) onPasswordChanged;
  final String? employeeIdError;
  final String? passwordError;
  final bool isLoading;

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  bool _isPasswordVisible = false;
  final FocusNode _employeeIdFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _employeeIdFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Employee ID Field
        _buildEmployeeIdField(theme, colorScheme),
        SizedBox(height: 2.h),

        // Password Field
        _buildPasswordField(theme, colorScheme),
      ],
    );
  }

  Widget _buildEmployeeIdField(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.employeeIdController,
          focusNode: _employeeIdFocusNode,
          enabled: !widget.isLoading,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(8),
          ],
          onChanged: widget.onEmployeeIdChanged,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
          decoration: InputDecoration(
            labelText: 'Employee ID',
            hintText: 'Enter your employee ID',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'badge',
                color: widget.employeeIdError != null
                    ? colorScheme.error
                    : colorScheme.onSurface.withValues(alpha: 0.6),
                size: 5.w,
              ),
            ),
            errorText: widget.employeeIdError,
            errorMaxLines: 2,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(
                color: colorScheme.outline,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(
                color: colorScheme.error,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(
                color: colorScheme.error,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: colorScheme.surface,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 3.h,
            ),
          ),
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.passwordController,
          focusNode: _passwordFocusNode,
          enabled: !widget.isLoading,
          obscureText: !_isPasswordVisible,
          textInputAction: TextInputAction.done,
          onChanged: widget.onPasswordChanged,
          onFieldSubmitted: (_) {
            FocusScope.of(context).unfocus();
          },
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'lock',
                color: widget.passwordError != null
                    ? colorScheme.error
                    : colorScheme.onSurface.withValues(alpha: 0.6),
                size: 5.w,
              ),
            ),
            suffixIcon: IconButton(
              onPressed: widget.isLoading
                  ? null
                  : () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
              icon: CustomIconWidget(
                iconName: _isPasswordVisible ? 'visibility_off' : 'visibility',
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                size: 5.w,
              ),
              tooltip: _isPasswordVisible ? 'Hide password' : 'Show password',
            ),
            errorText: widget.passwordError,
            errorMaxLines: 3,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(
                color: colorScheme.outline,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(
                color: colorScheme.error,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(
                color: colorScheme.error,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: colorScheme.surface,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 3.h,
            ),
          ),
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
}
