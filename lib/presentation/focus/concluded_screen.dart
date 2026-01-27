import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ConcludedScreen extends StatelessWidget {
  const ConcludedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.bgGradient,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              _buildDecorations(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    _buildSuccessIcon(),
                    const SizedBox(height: 32),
                    _buildTextSection(),
                    const SizedBox(height: 48),
                    _buildActionButton(context),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            color: AppColors.primaryPink.withValues(alpha:0.2),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            gradient: AppColors.fabGradient,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryPink.withValues(alpha:0.1),
                blurRadius: 40,
                offset: const Offset(0, 20),
              )
            ],
          ),
          child: const Icon(
            Icons.done_all_rounded,
            size: 60,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTextSection() {
    return const Column(
      children: [
        Text(
          'Sessão Concluída!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 36,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            height: 1.1,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Bom trabalho! Você completou todos os ciclos',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF64748B),
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Próxima Tarefa',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildDecorations() {
    return Stack(
      children: [
        Positioned(
          left: 45,
          top: 180,
          child: _shape(const Color(0xFFB794F4), 0.26),
        ),
        Positioned(
          left: 87,
          bottom: 150,
          child: _shape(const Color(0xFFB794F4), -0.35),
        ),
        Positioned(
          right: 40,
          bottom: 200,
          child: _shape(const Color(0xFFB794F4), 1.05),
        ),
      ],
    );
  }

  Widget _shape(Color color, double rotation) {
    return Opacity(
      opacity: 0.15,
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}