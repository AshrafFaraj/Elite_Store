import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';

class CartSummary extends StatelessWidget {
  final double totalAmount;
  final VoidCallback onCheckout;
  final bool isFloating;

  const CartSummary({
    super.key,
    required this.totalAmount,
    required this.onCheckout,
    this.isFloating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.rw(24)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: isFloating 
            ? BorderRadius.circular(context.rw(20)) 
            : BorderRadius.vertical(top: Radius.circular(context.rw(30))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), 
            blurRadius: context.rw(20), 
            offset: isFloating ? Offset(0, context.rh(10)) : Offset(0, context.rh(-5))
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('الإجمالي', style: TextStyle(color: AppColors.grey500, fontSize: context.sp(16))),
              Text(
                '\$${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: context.sp(24), fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: context.rh(24)),
          SizedBox(
            width: double.infinity,
            height: context.rh(55),
            child: ElevatedButton(
              onPressed: onCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.surface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.rw(15))),
              ),
              child: Text('إتمام الشراء', style: TextStyle(fontSize: context.sp(16), fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
