import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';
import 'package:jodohku_malaysia/src/features/onboarding/presentation/registration_screen.dart';

class OnboardingCarousel extends StatefulWidget {
  const OnboardingCarousel({super.key});

  @override
  State<OnboardingCarousel> createState() => _OnboardingCarouselState();
}

class _OnboardingCarouselState extends State<OnboardingCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _pages = [
    OnboardingItem(
      title: 'Taaruf Beradab',
      desc: 'Platform perkahwinan Islam #1 dengan pengesahan MyKad & Sijil JAKIM.',
      icon: Icons.mosque_outlined,
      color: AppColors.primaryGold,
    ),
    OnboardingItem(
      title: 'Sentinel AI 4.0',
      desc: 'Sistem sekuriti gred-bank yang memantau setiap bait perbualan demi maruah anda.',
      icon: Icons.shield_moon_outlined,
      color: AppColors.accentCyan,
    ),
    OnboardingItem(
      title: 'Restu Mahram',
      desc: 'Mod Wali memastikan setiap langkah mencari jodoh mendapat bimbingan keluarga.',
      icon: Icons.family_restroom_outlined,
      color: Colors.white,
    ),
    OnboardingItem(
      title: 'Sultan Mode',
      desc: 'Sertai ELITE SOVEREIGN untuk profil berprestij dan jemputan ke majlis eksklusif.',
      icon: Icons.diamond_outlined,
      color: AppColors.primaryGold,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // IMMERSIVE PAGE CONTENT
          PageView.builder(
            controller: _pageController,
            onPageChanged: (idx) => setState(() => _currentPage = idx),
            itemCount: _pages.length,
            itemBuilder: (context, idx) {
              final item = _pages[idx];
              return AnimatedContainer(
                duration: const Duration(seconds: 1),
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                   gradient: RadialGradient(
                    center: const Alignment(0, -0.3),
                    radius: 1.2,
                    colors: [item.color.withOpacity(0.08), AppColors.background],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.icon, size: 120, color: item.color),
                    const SizedBox(height: 80),
                    Text(item.title, style: GoogleFonts.outfit(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
                    const SizedBox(height: 24),
                    Text(item.desc, textAlign: TextAlign.center, style: GoogleFonts.outfit(fontSize: 16, color: AppColors.textSubtle, height: 1.8)),
                  ],
                ),
              );
            },
          ),
          
          // BOTTOM NAVIGATION & INDICATORS
          Positioned(
            bottom: 60, left: 40, right: 40,
            child: Column(
              children: [
                _buildDots(),
                const SizedBox(height: 56),
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage < 3) {
                      _pageController.nextPage(duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
                    } else {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RegistrationScreen()));
                    }
                  },
                  style: AppTheme.proButtonPrimary,
                  child: Text(_currentPage < 3 ? 'TERUSKAN →' : 'MULAKAN TAARUF'),
                ),
                const SizedBox(height: 24),
                if (_currentPage < 3)
                   GestureDetector(
                    onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RegistrationScreen())),
                    child: Text('LANGKAU KE PENDAFTARAN', style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white24, letterSpacing: 1.5)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (idx) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: _currentPage == idx ? 32 : 8,
        height: 4,
        decoration: BoxDecoration(color: _currentPage == idx ? AppColors.primaryGold : Colors.white10, borderRadius: BorderRadius.circular(100)),
      )),
    );
  }
}

class OnboardingItem {
  final String title, desc;
  final IconData icon;
  final Color color;
  OnboardingItem({required this.title, required this.desc, required this.icon, required this.color});
}
