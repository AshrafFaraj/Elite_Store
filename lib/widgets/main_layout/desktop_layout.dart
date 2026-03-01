import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import 'cart_icon_widget.dart';

class DesktopLayoutWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final List<Widget> pages;

  const DesktopLayoutWidget({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Row(
          children: [
            // Extended Navigation Rail is ideal for Desktop screens
            NavigationRail(
              extended:
                  true, // This makes it a full sidebar with text next to icons
              minExtendedWidth: context.rw(200),
              selectedIndex: currentIndex,
              onDestinationSelected: onIndexChanged,
              backgroundColor: AppColors.surface,
              selectedIconTheme: const IconThemeData(color: AppColors.primary),
              unselectedIconTheme:
                  const IconThemeData(color: AppColors.grey400),
              selectedLabelTextStyle: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: context.sp(14),
              ),
              unselectedLabelTextStyle: TextStyle(
                color: AppColors.grey400,
                fontSize: context.sp(14),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(LucideIcons.home),
                  label: Text('الرئيسية'),
                ),
                NavigationRailDestination(
                  icon: Icon(LucideIcons.heart),
                  label: Text('المفضلات'),
                ),
                NavigationRailDestination(
                  icon: CartIconWidget(),
                  label: Text('السلة'),
                ),
                NavigationRailDestination(
                  icon: Icon(LucideIcons.user),
                  label: Text('حسابي'),
                ),
              ],
            ),
            const VerticalDivider(
                thickness: 1, width: 1, color: AppColors.background),
            Expanded(
              child: IndexedStack(
                index: currentIndex,
                children: pages,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
