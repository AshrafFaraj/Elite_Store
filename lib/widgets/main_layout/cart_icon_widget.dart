import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../features/cart/presentation/bloc/cart_bloc.dart';
import '../../features/cart/presentation/bloc/cart_state.dart';

class CartIconWidget extends StatelessWidget {
  const CartIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        int count = 0;
        if (state is CartLoaded) {
          count = state.items.length;
        }
        return Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(LucideIcons.shoppingBag),
            if (count > 0)
              Positioned(
                right: -8,
                top: -8,
                child: Container(
                  padding: EdgeInsets.all(context.rw(4)),
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(
                    minWidth: context.rw(16),
                    minHeight: context.rw(16),
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      color: AppColors.surface,
                      fontSize: context.sp(10),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
