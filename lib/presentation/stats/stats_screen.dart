import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/custom_bottom_nav.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

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
                _buildSectionTitle('RESUMO DIÁRIO'),
                const SizedBox(height: 16),
                _buildDailySummary(),
                const SizedBox(height: 32),
                _buildSectionTitle('PRODUTIVIDADE SEMANAL'),
                const SizedBox(height: 16),
                _buildWeeklyChart(),
                const SizedBox(height: 32),
                _buildSectionTitle('SUA SEQUÊNCIA'),
                const SizedBox(height: 16),
                _buildStreakCard(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 16, bottom: 8),
      child: Center(
        child: Text(
            'Estatísticas',
            style: TextStyle(
                color: AppColors.textDark,
                fontSize: 24,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500
            )
        ),
      ),
    );
  }

  Widget _buildDailySummary() {
    return Row(
      children: [
        Expanded(child: _buildSummaryCard('4h 20m', 'Tempo Total', Icons.access_time_filled, AppColors.primaryPink)),
        const SizedBox(width: 16),
        Expanded(child: _buildSummaryCard('8', 'Pomodoros', Icons.timer, const Color(0xFFB794F4))),
      ],
    );
  }

  Widget _buildWeeklyChart() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBar(0.8, 'S'),
              _buildBar(0.7, 'T'),
              _buildBar(0.6, 'Q'),
              _buildBar(0.9, 'Q', isToday: true),
              _buildBar(0.4, 'S'),
              _buildBar(0.2, 'S'),
              _buildBar(0.1, 'D'),
            ],
          ),
          const Divider(height: 32, color: Color(0xFFF1F5F9)),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                CircleAvatar(radius: 4, backgroundColor: AppColors.primaryPink),
                SizedBox(width: 8),
                Text('Hoje', style: TextStyle(color: AppColors.textGrey, fontSize: 12))
              ]),
              Text('+15% vs semana passada', style: TextStyle(color: AppColors.textGrey, fontSize: 12, fontWeight: FontWeight.bold))
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStreakCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🔥 12 dias', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: AppColors.textDark)),
                  Text('Melhor marca: 24 dias', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                ],
              ),
              _buildCircleBtn(Icons.emoji_events_outlined, color: AppColors.primaryPink.withValues(alpha: 0.2)),
            ],
          ),
          const SizedBox(height: 24),
          _buildContributionGrid(),
          const SizedBox(height: 16),
          _buildGridLegend(),
        ],
      ),
    );
  }

  Widget _buildBar(double heightFactor, String day, {bool isToday = false}) {
    return Column(
      children: [
        Container(
          width: 16,
          height: 100 * heightFactor,
          decoration: BoxDecoration(
            color: isToday ? AppColors.primaryPink : AppColors.primaryPink.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 8),
        Text(day, style: TextStyle(color: isToday ? AppColors.primaryPink : AppColors.textGrey, fontWeight: isToday ? FontWeight.bold : FontWeight.normal, fontSize: 10)),
      ],
    );
  }

  Widget _buildContributionGrid() {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: List.generate(21, (index) {
        return Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: AppColors.primaryPink.withValues(alpha: 0.3 * ((index % 5) * 0.2)),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          Text(label, style: const TextStyle(color: AppColors.textGrey, fontSize: 11)),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white.withValues(alpha: 0.5),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
  );

  Widget _buildSectionTitle(String title) => Text(title, style: const TextStyle(color: AppColors.textGrey, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.4));

  Widget _buildCircleBtn(IconData icon, {Color? color, VoidCallback? onTap}) => InkWell(
    onTap: onTap,
    child: Container(
      width: 40, height: 40,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color ?? Colors.white.withValues(alpha: 0.5), border: Border.all(color: Colors.white.withValues(alpha: 0.4))),
      child: Icon(icon, size: 20, color: AppColors.textDark),
    ),
  );

  Widget _buildGridLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text('Menos ', style: TextStyle(color: AppColors.textGrey, fontSize: 10)),
        ...List.generate(3, (i) => Container(
          width: 8, height: 8, margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(color: AppColors.primaryPink.withValues(alpha: 0.3 * (i + 1)), borderRadius: BorderRadius.circular(2)),
        )),
        const Text(' Mais', style: TextStyle(color: AppColors.textGrey, fontSize: 10)),
      ],
    );
  }
}