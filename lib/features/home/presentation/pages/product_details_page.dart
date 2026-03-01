import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/product.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../../cart/presentation/bloc/cart_state.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowRight,
              color: AppColors.primary, size: context.sp(24)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              int count = 0;
              if (state is CartLoaded) {
                count = state.items.length;
              }
              return IconButton(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(LucideIcons.shoppingCart,
                        color: AppColors.primary, size: context.sp(24)),
                    if (count > 0)
                      Positioned(
                        right: -4,
                        top: -4,
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
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  );
                },
              );
            },
          ),
          SizedBox(width: context.rw(8)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(context.rw(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Center(
                    child: Hero(
                      tag: 'product_${product.id}',
                      child: Container(
                        height: context.rh(300),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(context.rw(16)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(context.rw(16)),
                        child: Image.network(
                          product.image,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: context.rh(24)),

                  // Category & Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: context.rw(12),
                            vertical: context.rh(6)),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(context.rw(20)),
                        ),
                        child: Text(
                          product.category.toUpperCase(),
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: context.sp(12),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(LucideIcons.star,
                              color: Colors.amber, size: context.sp(18)),
                          SizedBox(width: context.rw(4)),
                          Text(
                            product.rating.rate.toString(),
                            style: TextStyle(
                              fontSize: context.sp(14),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' (${product.rating.count} تقييم)',
                            style: TextStyle(
                              fontSize: context.sp(12),
                              color: AppColors.grey400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: context.rh(16)),

                  // Title
                  Text(
                    product.title,
                    style: TextStyle(
                      fontSize: context.sp(20),
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: context.rh(16)),

                  // Description
                  Text(
                    'وصف المنتج',
                    style: TextStyle(
                      fontSize: context.sp(16),
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: context.rh(8)),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: context.sp(14),
                      color: AppColors.grey400,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: context.rh(24)),
                ],
              ),
            ),
          ),

          // Bottom Bar (Price & Add to Cart)
          Container(
            padding: EdgeInsets.all(context.rw(20)),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(context.rw(24))),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'السعر الإجمالي',
                        style: TextStyle(
                          fontSize: context.sp(12),
                          color: AppColors.grey400,
                        ),
                      ),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: context.sp(24),
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: context.rw(24)),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CartBloc>().add(
                              AddToCartEvent(
                                  CartItem(product: product, quantity: 1)),
                            );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                const Text('تمت إضافة المنتج إلى السلة بنجاح'),
                            backgroundColor: AppColors.success,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: context.rh(16)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(context.rw(16)),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LucideIcons.shoppingBag, size: context.sp(20)),
                          SizedBox(width: context.rw(8)),
                          Text(
                            'أضف إلى السلة',
                            style: TextStyle(
                              fontSize: context.sp(16),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
