import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/category_filter.dart';
import '../widgets/logout_button.dart';
import '../widgets/product_grid.dart';
import '../widgets/ad_banner.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../widgets/search_button.dart';
import '../widgets/store_title.dart';
import '../widgets/user_image.dart';

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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: EdgeInsets.only(
                top: context.rw(8),
                bottom: context.rw(8),
                right: context.rw(16)),
            child: const UserImage(),
          ),
          title: const StoreTitle(),
          actions: [
            const Search(),
            const LogOutButton(),
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
              child: Directionality(
                  textDirection: TextDirection.ltr, child: ProductGrid()),
            ),
          ],
        ),
      ),
    );
  }
}
