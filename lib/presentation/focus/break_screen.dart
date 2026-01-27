import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/timer_painter.dart';

class BreakScreen extends StatelessWidget {
  const BreakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.breakBgGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              _buildTimerSection(),
              const Spacer(),
              _buildActiveTaskCard(),
              _buildActionButtons(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTimerSection() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 321,
              height: 321,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0x3394A3F4)),
              ),
            ),
            Container(
              width: 288,
              height: 288,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha:0.4),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha:0.2), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x4C94A3F4),
                    blurRadius: 80,
                    spreadRadius: -10,
                  )
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 280,
                    height: 280,
                    child: CustomPaint(
                      painter: TimerPainter(progress: 0.2),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "05:00",
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.w300,
                          color: AppColors.textDark,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const Text(
                        "INTERVALO",
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF94A3F4),
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 48),
        const Text(
          "Hora de Relaxar",
          style: TextStyle(
            fontSize: 30,
            color: AppColors.textDark,
            fontFamily: 'Poppins',
          ),
        ),
        const Text(
          "Respire fundo",
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textGrey,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 16),
        _buildDotIndicator(),
      ],
    );
  }

  Widget _buildDotIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _dot(AppColors.primaryPink),
        _dot(const Color(0xFF94A3F4), hasShadow: true),
        _dot(const Color(0xFFE2E8F0)),
        _dot(const Color(0xFFE2E8F0)),
      ],
    );
  }

  Widget _dot(Color color, {bool hasShadow = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: hasShadow
            ? [BoxShadow(color: color.withValues(alpha:0.8), blurRadius: 4)]
            : null,
      ),
    );
  }

  Widget _buildActiveTaskCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const Row(
        children: [
          Icon(Icons.check_circle_outline, size: 20, color: AppColors.primaryPink),
          SizedBox(width: 12),
          Text(
            "Estudar UI Design",
            style: TextStyle(color: Color(0xFF334155), fontWeight: FontWeight.w500),
          ),
          Spacer(),
          Icon(Icons.more_vert, color: Color(0xFF334155), size: 20),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F172A),
              minimumSize: const Size(double.infinity, 64),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            ),
            child: const Text(
              "Iniciar Pausa",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildSecondaryBtn("Reiniciar")),
              const SizedBox(width: 16),
              Expanded(child: _buildSecondaryBtn("Pular Pausa")),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryBtn(String label) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.4),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha:0.2)),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(color: Color(0xFF334155), fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: Colors.white,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavIcon(Icons.timer_rounded, "FOCO", true),
          _NavIcon(Icons.list_alt_rounded, "TAREFAS", false),
          _NavIcon(Icons.bar_chart_rounded, "STATUS", false),
          _NavIcon(Icons.settings_outlined, "AJUSTES", false),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  const _NavIcon(this.icon, this.label, this.active);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: active ? const Color(0xFFEC6888) : AppColors.textGrey),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: active ? const Color(0xFFEC6888) : AppColors.textGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}