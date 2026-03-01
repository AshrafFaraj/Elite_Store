import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import 'email_form.dart';
import 'phone_form.dart';
import 'login_toggle_switch.dart';

class LoginInputScreen extends StatelessWidget {
  final bool isPhoneLogin;
  final ValueChanged<bool> onToggleLoginType;
  final String? errorMessage;
  final VoidCallback onLogin;

  // Controllers
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController phoneController;

  // Phone specific
  final String selectedCountryCode;
  final List<Map<String, String>> countryCodes;
  final ValueChanged<String> onCountryCodeChanged;

  const LoginInputScreen({
    super.key,
    required this.isPhoneLogin,
    required this.onToggleLoginType,
    this.errorMessage,
    required this.onLogin,
    required this.emailController,
    required this.passwordController,
    required this.phoneController,
    required this.selectedCountryCode,
    required this.countryCodes,
    required this.onCountryCodeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('input_screen'),
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 420),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.grey100),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF27272A), AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(LucideIcons.shoppingBag,
                color: Colors.white, size: 36),
          ),
          const SizedBox(height: 32),
          const Text(
            'مرحباً بك',
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: -0.5),
          ),
          const SizedBox(height: 8),
          const Text(
            'سجل دخولك للمتابعة في متجر النخبة',
            style: TextStyle(
                color: AppColors.secondary,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 40),

          // Toggle Switch
          LoginToggleSwitch(
            isPhoneLogin: isPhoneLogin,
            onChanged: onToggleLoginType,
          ),

          if (errorMessage != null) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.error.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.alertCircle,
                      color: AppColors.error, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(
                          color: AppColors.error,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 32),

          // Forms
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.05),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: isPhoneLogin
                ? PhoneForm(
                    phoneController: phoneController,
                    selectedCountryCode: selectedCountryCode,
                    countryCodes: countryCodes,
                    onCountryCodeChanged: onCountryCodeChanged,
                  )
                : EmailForm(
                    emailController: emailController,
                    passwordController: passwordController,
                  ),
          ),

          const SizedBox(height: 32),

          // Login Button
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: state is AuthLoading ? null : onLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: state is AuthLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5),
                        )
                      : Text(
                          isPhoneLogin ? 'إرسال كود التحقق' : 'تسجيل الدخول',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5),
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
