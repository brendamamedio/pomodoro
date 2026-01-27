import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/custom_bottom_nav.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 32),
                _buildSectionTitle('DURAÇÃO DOS CICLOS'),
                const SizedBox(height: 16),
                _buildTimerSettings(),
                const SizedBox(height: 32),
                _buildLongBreakFrequency(context),
                const SizedBox(height: 32),
                _buildSectionTitle('NOTIFICAÇÕES'),
                const SizedBox(height: 16),
                _buildNotificationSettings(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
      
      bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        'Configurações',
        style: TextStyle(
          color: AppColors.textDark,
          fontSize: 24,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTimerSettings() {
    return Column(
      children: [
        _buildSettingTile('Foco', '25', AppColors.primaryPink, Icons.center_focus_strong),
        const SizedBox(height: 12),
        _buildSettingTile('Pausa Curta', '5', const Color(0xFFB794F4), Icons.coffee),
        const SizedBox(height: 12),
        _buildSettingTile('Pausa Longa', '15', const Color(0xFF94A3B8), Icons.hotel),
      ],
    );
  }

  Widget _buildLongBreakFrequency(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle('FREQUÊNCIA DE PAUSA LONGA'),
            const Text(
              'A cada 4 Pomodoros',
              style: TextStyle(
                  color: AppColors.primaryPink,
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
          decoration: _cardDecoration(),
          child: Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.primaryPink,
                  inactiveTrackColor: const Color(0xFFE2E8F0),
                  thumbColor: AppColors.primaryPink,
                  overlayColor: AppColors.primaryPink.withValues(alpha:0.1),
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                ),
                child: Slider(
                    value: 4,
                    min: 1,
                    max: 10,
                    onChanged: (v) {}
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('1', style: TextStyle(color: AppColors.textGrey, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                  Text('10', style: TextStyle(color: AppColors.textGrey, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _buildSwitchTile('Sons', Icons.volume_up_rounded, true),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          _buildSwitchTile('Vibração', Icons.vibration_rounded, true),
        ],
      ),
    );
  }

  Widget _buildSettingTile(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                    color: color.withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(16)
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(color: Color(0xFF334155), fontSize: 16, fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
            ],
          ),
          _buildCounter(value, color),
        ],
      ),
    );
  }

  Widget _buildCounter(String value, Color color) {
    return Row(
      children: [
        _buildRoundActionBtn('-', const Color(0xFF64748B), Colors.transparent),
        SizedBox(width: 32, child: Text(value, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontFamily: 'Poppins', fontWeight: FontWeight.w600))),
        _buildRoundActionBtn('+', color, color.withValues(alpha:0.2)),
      ],
    );
  }

  Widget _buildSwitchTile(String label, IconData icon, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.textGrey, size: 24),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(color: Color(0xFF334155), fontSize: 16, fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
            ],
          ),
          Switch(
              value: value,
              activeThumbColor: AppColors.primaryPink,
              onChanged: (v) {}
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white.withValues(alpha:0.6),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: const Color(0xFFE2E8F0)),
  );

  Widget _buildSectionTitle(String title) => Text(
      title,
      style: const TextStyle(
          color: AppColors.textGrey,
          fontSize: 12,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          letterSpacing: 1.2
      )
  );

  Widget _buildRoundActionBtn(String label, Color color, Color bgColor) {
    return Container(
      width: 32, height: 32,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bgColor,
          border: Border.all(color: const Color(0xFFE2E8F0))
      ),
      child: Center(child: Text(label, style: TextStyle(color: color, fontSize: 16, fontFamily: 'Poppins'))),
    );
  }
}