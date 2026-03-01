import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../widgets/category_filter.dart';
import '../widgets/product_grid.dart';
import '../widgets/ad_banner.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'all';

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchProductsEvent());
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    if (category == 'all') {
      context.read<ProductBloc>().add(FetchProductsEvent());
    } else {
      context.read<ProductBloc>().add(FetchProductsByCategoryEvent(category));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(context.rw(8)),
          child: CircleAvatar(
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Icon(LucideIcons.user,
                color: AppColors.primary, size: context.sp(20)),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'مرحباً بك 👋',
              style:
                  TextStyle(color: AppColors.grey400, fontSize: context.sp(12)),
            ),
            Text(
              'متجر النخبة',
              style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: context.sp(16)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(LucideIcons.search,
                color: AppColors.primary, size: context.sp(24)),
            onPressed: () {},
          ),
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
          const AdBanner(),
          CategoryFilter(
            selectedCategory: _selectedCategory,
            onCategorySelected: _onCategorySelected,
          ),
          const Expanded(
            child: ProductGrid(),
          ),
        ],
      ),
    );
  }
}
