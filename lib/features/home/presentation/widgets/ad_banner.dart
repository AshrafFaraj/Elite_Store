import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';

class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, String>> _ads = [
    {
      'image': 'https://picsum.photos/seed/ad1/800/400',
      'title': 'خصم 50% على الإلكترونيات',
    },
    {
      'image': 'https://picsum.photos/seed/ad2/800/400',
      'title': 'تشكيلة الصيف الجديدة',
    },
    {
      'image': 'https://picsum.photos/seed/ad3/800/400',
      'title': 'توصيل مجاني اليوم',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _ads.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.rh(150),
      margin: EdgeInsets.symmetric(horizontal: context.rw(16), vertical: context.rh(8)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.rw(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: context.rw(10),
            offset: Offset(0, context.rh(5)),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.rw(16)),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemCount: _ads.length,
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      _ads[index]['image']!,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: context.rh(16),
                      left: context.rw(16),
                      right: context.rw(16),
                      child: Text(
                        _ads[index]['title']!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: context.sp(18),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              },
            ),
            Positioned(
              bottom: context.rh(8),
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _ads.length,
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: context.rw(4)),
                    width: _currentPage == index ? context.rw(24) : context.rw(8),
                    height: context.rh(8),
                    decoration: BoxDecoration(
                      color: _currentPage == index ? AppColors.primary : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(context.rw(4)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
