import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class LoginToggleSwitch extends StatelessWidget {
  final bool isPhoneLogin;
  final ValueChanged<bool> onChanged;

  const LoginToggleSwitch({
    super.key,
    required this.isPhoneLogin,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !isPhoneLogin ? AppColors.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: !isPhoneLogin 
                    ? [const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))] 
                    : null,
                ),
                child: Center(
                  child: Text(
                    'البريد الإلكتروني', 
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: !isPhoneLogin ? FontWeight.bold : FontWeight.w500,
                      color: !isPhoneLogin ? AppColors.primary : AppColors.secondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isPhoneLogin ? AppColors.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isPhoneLogin 
                    ? [const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))] 
                    : null,
                ),
                child: Center(
                  child: Text(
                    'رقم الجوال', 
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isPhoneLogin ? FontWeight.bold : FontWeight.w500,
                      color: isPhoneLogin ? AppColors.primary : AppColors.secondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
