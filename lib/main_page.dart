import 'package:elite_store/widgets/main_layout/tablet_layout.dart';
import 'package:flutter/material.dart';
import 'core/utils/responsive.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/cart/presentation/pages/cart_page.dart';
import 'features/favorites/presentation/pages/favorites_page.dart';
import 'widgets/main_layout/mobile_layout.dart';
import 'widgets/main_layout/desktop_layout.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const FavoritesPage(),
    const CartPage(),
    const Center(child: Text('الملف الشخصي')),
  ];

  void _onIndexChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: MobileLayoutWidget(
        currentIndex: _currentIndex,
        onIndexChanged: _onIndexChanged,
        pages: _pages,
      ),
      tablet: TabletLayoutWidget(
        currentIndex: _currentIndex,
        onIndexChanged: _onIndexChanged,
        pages: _pages,
      ),
      desktop: DesktopLayoutWidget(
        currentIndex: _currentIndex,
        onIndexChanged: _onIndexChanged,
        pages: _pages,
      ),
    );
  }
}
