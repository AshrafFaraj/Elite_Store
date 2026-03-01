import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/cart_summary.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'سلة التسوق',
          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: context.sp(20)),
        ),
        iconTheme: IconThemeData(color: AppColors.primary, size: context.sp(24)),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: AppColors.error, size: context.sp(24)),
            onPressed: () {
              context.read<CartBloc>().add(ClearCartEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          } else if (state is CartLoaded) {
            if (state.items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: context.rw(80), color: AppColors.grey300),
                    SizedBox(height: context.rh(16)),
                    Text('سلتك فارغة حالياً', style: TextStyle(color: AppColors.grey500, fontSize: context.sp(18))),
                  ],
                ),
              );
            }

            return Responsive(
              mobile: _buildMobileLayout(context, state),
              tablet: _buildDesktopLayout(context, state), // Use desktop layout for tablet as well
              desktop: _buildDesktopLayout(context, state),
            );
          } else if (state is CartError) {
            return Center(child: Text(state.message, style: TextStyle(fontSize: context.sp(16))));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, CartLoaded state) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(context.rw(16)),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              return CartItemTile(item: state.items[index]);
            },
          ),
        ),
        CartSummary(
          totalAmount: state.totalAmount,
          onCheckout: () {
            // إتمام الطلب
          },
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, CartLoaded state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: ListView.builder(
            padding: EdgeInsets.all(context.rw(16)),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              return CartItemTile(item: state.items[index]);
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.all(context.rw(16)),
            child: CartSummary(
              isFloating: true,
              totalAmount: state.totalAmount,
              onCheckout: () {
                // إتمام الطلب
              },
            ),
          ),
        ),
      ],
    );
  }
}
