import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/cart_item.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;

  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.rh(16)),
      padding: EdgeInsets.all(context.rw(12)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.rw(20)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.03),
            blurRadius: context.rw(10),
            offset: Offset(0, context.rh(5)),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: context.rw(80),
            height: context.rw(80),
            padding: EdgeInsets.all(context.rw(8)),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(context.rw(15)),
            ),
            child: Image.network(item.product.image, fit: BoxFit.contain),
          ),
          SizedBox(width: context.rw(16)),
          
          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: context.sp(14)),
                ),
                SizedBox(height: context.rh(4)),
                Text(
                  '\$${item.product.price}',
                  style: TextStyle(color: AppColors.grey500, fontWeight: FontWeight.w600, fontSize: context.sp(14)),
                ),
                SizedBox(height: context.rh(8)),
                
                // Quantity Controls
                Row(
                  children: [
                    _quantityButton(
                      context: context,
                      icon: Icons.remove,
                      onTap: () {
                        context.read<CartBloc>().add(
                          UpdateQuantityEvent(item.product.id, item.quantity - 1),
                        );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.rw(12)),
                      child: Text(
                        item.quantity.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: context.sp(14)),
                      ),
                    ),
                    _quantityButton(
                      context: context,
                      icon: Icons.add,
                      onTap: () {
                        context.read<CartBloc>().add(
                          UpdateQuantityEvent(item.product.id, item.quantity + 1),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Remove Button
          IconButton(
            icon: Icon(Icons.close, color: AppColors.grey500, size: context.sp(20)),
            onPressed: () {
              context.read<CartBloc>().add(RemoveFromCartEvent(item.product.id));
            },
          ),
        ],
      ),
    );
  }

  Widget _quantityButton({required BuildContext context, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(context.rw(4)),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey300),
          borderRadius: BorderRadius.circular(context.rw(8)),
        ),
        child: Icon(icon, size: context.sp(16), color: AppColors.primary),
      ),
    );
  }
}
