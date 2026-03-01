import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';

class PhoneForm extends StatelessWidget {
  final TextEditingController phoneController;
  final String selectedCountryCode;
  final List<Map<String, String>> countryCodes;
  final ValueChanged<String> onCountryCodeChanged;

  const PhoneForm({
    super.key,
    required this.phoneController,
    required this.selectedCountryCode,
    required this.countryCodes,
    required this.onCountryCodeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('phone_form'),
      child: Row(
        children: [
          Container(
            width: 120,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.grey200),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedCountryCode,
                icon: const Icon(LucideIcons.chevronDown, color: AppColors.grey500, size: 18),
                isExpanded: true,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                items: countryCodes.map((country) {
                  return DropdownMenuItem<String>(
                    value: country['code'],
                    child: Text(
                      '${country['flag']} ${country['code']}', 
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.primary),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    onCountryCodeChanged(value);
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.grey200),
              ),
              child: TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.primary, letterSpacing: 1),
                decoration: const InputDecoration(
                  hintText: '5X XXX XXXX',
                  hintStyle: TextStyle(color: AppColors.grey400, letterSpacing: 1),
                  prefixIcon: Icon(LucideIcons.phone, color: AppColors.grey500, size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
