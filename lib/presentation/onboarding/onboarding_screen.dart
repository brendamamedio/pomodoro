import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Foque no que\nimporta',
      'description':
      'A técnica Pomodoro ajuda você a manter a\nconcentração máxima por 25 minutos,\nseguidos de uma pausa revigorante.',
    },
    {
      'title': 'Organize suas\nTarefas',
      'description':
      'Vincule seus ciclos de foco a objetivos\nespecíficos para acompanhar sua\nprodutividade real em cada projeto.',
    },
    {
      'title': 'Acompanhe seu\nProgresso',
      'description':
      'Veja sua evolução através de\nestatísticas detalhadas e mantenha sua\nsequência de dias produtivos.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    bool isLastPage = _currentPage == _onboardingData.length - 1;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: isLastPage
              ? const LinearGradient(
            begin: Alignment(-0.45, 0.16),
            end: Alignment(1.45, 0.84),
            colors: [Color(0xFFFF7597), Color(0xFF8E54E9)],
          )
              : AppColors.bgGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (value) => setState(() => _currentPage = value),
                  itemCount: _onboardingData.length,
                  itemBuilder: (context, index) => _buildPageContent(index, isLastPage),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                child: Column(
                  children: [
                    _buildPageIndicator(isLastPage),
                    const SizedBox(height: 24),
                    _buildNextButton(isLastPage),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent(int index, bool isLastPage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIllustrationSection(index),
          const SizedBox(height: 48),
          Text(
            _onboardingData[index]['title']!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isLastPage ? Colors.white : AppColors.textDark,
              fontSize: 36,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              height: 1.1,
              letterSpacing: -0.9,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _onboardingData[index]['description']!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isLastPage ? Colors.white.withValues(alpha:0.9) : const Color(0xFF64748B),
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w300,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustrationSection(int index) {
    return SizedBox(
      height: 256,
      width: 256,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0.5,
            child: Container(
              width: 256,
              height: 256,
              decoration: BoxDecoration(
                color: index == 2 ? Colors.white.withValues(alpha:0.3) : AppColors.primaryPink.withValues(alpha:0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          if (index == 2) _buildThirdIllustration() else _buildSimpleIllustration(index),
        ],
      ),
    );
  }

  Widget _buildSimpleIllustration(int index) {
    return Container(
      width: 192,
      height: 192,
      decoration: _illustrationDecoration(),
      child: Center(
        child: Icon(
          index == 0 ? Icons.timer_outlined : Icons.assignment_outlined,
          size: 80,
          color: AppColors.primaryPink,
        ),
      ),
    );
  }

  Widget _buildThirdIllustration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 208,
          height: 208,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha:0.2),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha:0.4)),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha:0.4),
                blurRadius: 80,
              )
            ],
          ),
          child: const Center(
            child: Icon(Icons.show_chart_rounded, size: 80, color: Colors.white),
          ),
        ),
        Positioned(
          right: 0,
          top: 16,
          child: _miniBadge(Icons.local_fire_department_rounded),
        ),
        Positioned(
          left: 8,
          bottom: 24,
          child: _miniBadge(Icons.star_rounded, size: 40),
        ),
      ],
    );
  }

  Widget _miniBadge(IconData icon, {double size = 48}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.3),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha:0.2)),
      ),
      child: Icon(icon, color: Colors.white, size: size * 0.5),
    );
  }

  BoxDecoration _illustrationDecoration() {
    return BoxDecoration(
      color: Colors.white.withValues(alpha:0.9),
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white.withValues(alpha:0.3)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha:0.05),
          blurRadius: 30,
          offset: const Offset(0, 10),
        )
      ],
    );
  }

  Widget _buildPageIndicator(bool isLastPage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _onboardingData.length,
            (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 8,
          width: _currentPage == index ? 28 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? (isLastPage ? Colors.white : AppColors.primaryPink)
                : (isLastPage ? Colors.white.withValues(alpha:0.4) : const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(bool isLastPage) {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: isLastPage ? BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF581C87).withValues(alpha:0.4),
            blurRadius: 50,
            offset: const Offset(0, 25),
            spreadRadius: -12,
          )
        ],
      ) : null,
      child: ElevatedButton(
        onPressed: () {
          if (_currentPage < _onboardingData.length - 1) {
            _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
          } else {
            
            Navigator.pushReplacementNamed(context, AppRoutes.tasks);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLastPage ? 'Começar Agora' : 'Próximo',
              style: const TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Poppins', fontWeight: FontWeight.w600),
            ),
            if (isLastPage) ...[
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded, color: Colors.white),
            ]
          ],
        ),
      ),
    );
  }
}