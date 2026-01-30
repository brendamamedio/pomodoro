import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.bgGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(),
                _buildIllustration(),
                const Spacer(),
                _buildTexts(),
                const SizedBox(height: 48),
                _buildActionButtons(context),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        shape: BoxShape.circle,
        boxShadow: AppColors.softShadow,
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.person_pin_rounded,
              size: 100,
              color: AppColors.primaryPink,
            );
          },
        ),
      ),
    );
  }

  Widget _buildTexts() {
    return const Column(
      children: [
        Text(
          'Explore o aplicativo',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 32,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Agora suas tarefas e tempo estão em um só lugar e sempre sob controle',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 17,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.login);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F172A),
            minimumSize: const Size(double.infinity, 64),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Entrar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.signup);
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 64),
            side: const BorderSide(color: Color(0xFF737373)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          ),
          child: const Text(
            'Criar uma conta',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}