import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import 'cart_icon_widget.dart';

class MobileLayoutWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final List<Widget> pages;

  const MobileLayoutWidget({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
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
          currentIndex: currentIndex,
          onTap: onIndexChanged,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.grey400,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: TextStyle(
            fontSize: context.sp(12),
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(fontSize: context.sp(12)),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.home),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.heart),
              label: 'المفضلات',
            ),
            BottomNavigationBarItem(
              icon: CartIconWidget(),
              label: 'السلة',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.user),
              label: 'حسابي',
            ),
          ],
        ),
      ),
    );
  }
}
