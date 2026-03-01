import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_state.dart';
import 'product_card.dart';
import '../pages/product_details_page.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/theme/app_colors.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        } else if (state is ProductLoaded) {
          if (state.products.isEmpty) {
            return Center(
                child: Text('لا توجد منتجات حالياً',
                    style: TextStyle(fontSize: context.sp(16))));
          }

          final int crossAxisCount = Responsive.isDesktop(context)
              ? 4
              : Responsive.isTablet(context)
                  ? 3
                  : 2;

          return GridView.builder(
            padding: EdgeInsets.all(context.rw(16)),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.7,
              crossAxisSpacing: context.rw(16),
              mainAxisSpacing: context.rh(16),
            ),
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              return ProductCard(
                product: state.products[index],
                heroTag: 'home_product_${state.products[index].id}',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsPage(
                        product: state.products[index],
                        heroTag: 'home_product_${state.products[index].id}',
                      ),
                    ),
                  );
                },
              );
            },
          );
        } else if (state is ProductError) {
          return Center(
              child: Text(state.message,
                  style: TextStyle(fontSize: context.sp(16))));
        }
        return const SizedBox();
      },
    );
  }
}
