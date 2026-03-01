import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

class OtpScreen extends StatelessWidget {
  final VoidCallback onBack;
  final String selectedCountryCode;
  final String phoneNumber;
  final String? errorMessage;
  final VoidCallback onVerify;
  final List<TextEditingController> otpControllers;
  final List<FocusNode> otpFocusNodes;
  final ValueChanged<String?> onOtpChanged;

  const OtpScreen({
    super.key,
    required this.onBack,
    required this.selectedCountryCode,
    required this.phoneNumber,
    this.errorMessage,
    required this.onVerify,
    required this.otpControllers,
    required this.otpFocusNodes,
    required this.onOtpChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('otp_screen'),
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
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: onBack,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.arrowRight,
                        size: 18, color: AppColors.secondary),
                    SizedBox(width: 8),
                    Text('رجوع',
                        style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

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
            child: const Icon(LucideIcons.shieldCheck,
                color: Colors.white, size: 36),
          ),
          const SizedBox(height: 32),
          const Text(
            'تأكيد الرقم',
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: -0.5),
          ),
          const SizedBox(height: 12),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                  color: AppColors.secondary,
                  fontSize: 16,
                  fontFamily: 'Tajawal',
                  height: 1.5),
              children: [
                const TextSpan(
                    text: 'أدخل الكود المكون من 4 أرقام المرسل إلى\n'),
                TextSpan(
                  text: '$selectedCountryCode $phoneNumber',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: 1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          if (errorMessage != null) ...[
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
            const SizedBox(height: 32),
          ],

          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 64,
                  height: 72,
                  child: TextField(
                    controller: otpControllers[index],
                    focusNode: otpFocusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: AppColors.grey50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: AppColors.grey200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: AppColors.grey200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 3) {
                        otpFocusNodes[index + 1].requestFocus();
                      } else if (value.isEmpty && index > 0) {
                        otpFocusNodes[index - 1].requestFocus();
                      }
                      onOtpChanged(value);
                    },
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 48),

          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: state is AuthLoading ? null : onVerify,
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
                      : const Text('تحقق',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5)),
                ),
              );
            },
          ),

          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('لم يصلك الكود؟ ',
                  style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500)),
              GestureDetector(
                onTap: () {},
                child: const Text('إعادة إرسال',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
