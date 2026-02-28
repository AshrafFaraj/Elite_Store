import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'core/theme/app_colors.dart';
import 'core/utils/responsive.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    // const ProductsPage(),
    // const FavoritesPage(),
    // const CartPage(),
    const Center(child: Text('الملف الشخصي')),
  ];

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _buildMobileLayout(context),
      tablet: _buildDesktopLayout(context),
      desktop: _buildDesktopLayout(context),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.05),
              blurRadius: context.rw(20),
              offset: Offset(0, context.rh(-5)),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.grey400,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle:
              TextStyle(fontSize: context.sp(12), fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontSize: context.sp(12)),
          elevation: 0,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(LucideIcons.home),
              label: 'الرئيسية',
            ),
            const BottomNavigationBarItem(
              icon: Icon(LucideIcons.heart),
              label: 'المفضلات',
            ),
            // BottomNavigationBarItem(
            //   icon: _buildCartIcon(context),
            //   label: 'السلة',
            // ),
            const BottomNavigationBarItem(
              icon: Icon(LucideIcons.user),
              label: 'حسابي',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            backgroundColor: AppColors.surface,
            selectedIconTheme: const IconThemeData(color: AppColors.primary),
            unselectedIconTheme: const IconThemeData(color: AppColors.grey400),
            selectedLabelTextStyle: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: context.sp(12)),
            unselectedLabelTextStyle:
                TextStyle(color: AppColors.grey400, fontSize: context.sp(12)),
            destinations: [
              const NavigationRailDestination(
                icon: Icon(LucideIcons.home),
                label: Text('الرئيسية'),
              ),
              const NavigationRailDestination(
                icon: Icon(LucideIcons.heart),
                label: Text('المفضلات'),
              ),
              // NavigationRailDestination(
              //   icon: _buildCartIcon(context),
              //   label: const Text('السلة'),
              // ),
              const NavigationRailDestination(
                icon: Icon(LucideIcons.user),
                label: Text('حسابي'),
              ),
            ],
          ),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: _pages,
            ),
          ),
        ],
      ),
    );
  }

//   Widget _buildCartIcon(BuildContext context) {
//     return BlocBuilder<CartBloc, CartState>(
//       builder: (context, state) {
//         int count = 0;
//         if (state is CartLoaded) {
//           count = state.items.length;
//         }
//         return Stack(
//           clipBehavior: Clip.none,
//           children: [
//             const Icon(LucideIcons.shoppingBag),
//             if (count > 0)
//               Positioned(
//                 right: -8,
//                 top: -8,
//                 child: Container(
//                   padding: EdgeInsets.all(context.rw(4)),
//                   decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
//                   constraints: BoxConstraints(minWidth: context.rw(16), minHeight: context.rw(16)),
//                   child: Text(
//                     count.toString(),
//                     style: TextStyle(color: AppColors.surface, fontSize: context.sp(10), fontWeight: FontWeight.bold),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//           ],
//         );
//       },
//     );
//   }
}
