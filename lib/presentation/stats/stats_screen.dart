import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/custom_bottom_nav.dart';
import '../../services/auth_service.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final AuthService _authService = AuthService();
  Map<String, double> _weeklyStats = {};
  int _currentStreak = 0;
  List<double> _contributionData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    final stats = await _authService.getWeeklyFocusStats();
    final streak = await _authService.getCurrentStreak();
    final contributions = await _authService.getContributionData();

    if (mounted) {
      setState(() {
        _weeklyStats = stats;
        _currentStreak = streak;
        _contributionData = contributions;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primaryPink))
              : SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
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

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.only(top: 16, bottom: 8),
      child: Center(
        child: Text(
          'Estatísticas',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 24,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDailySummary() {
    double totalMinutes = _weeklyStats.values.fold(0, (sum, item) => sum + item);
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            '${(totalMinutes / 60).toStringAsFixed(1)}h',
            'Tempo Total',
            Icons.access_time_filled,
            AppColors.primaryPink,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            (totalMinutes / 25).round().toString(),
            'Pomodoros',
            Icons.timer,
            const Color(0xFFB794F4),
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyChart() {
    final maxMinutes = _weeklyStats.values.isEmpty ? 1.0 : _weeklyStats.values.reduce((a, b) => a > b ? a : b);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _weeklyStats.entries.map((entry) {
              final percentage = maxMinutes > 0 ? entry.value / maxMinutes : 0.0;
              return _buildBar(percentage, entry.key);
            }).toList(),
          ),
          const Divider(height: 32, color: Color(0xFFF1F5F9)),
          Row(
            children: [
              const CircleAvatar(radius: 4, backgroundColor: AppColors.primaryPink),
              const SizedBox(width: 8),
              const Text('Hoje', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBar(double heightFactor, String day) {
    bool isToday = _isToday(day);
    return Column(
      children: [
        Container(
          width: 16,
          height: 100 * heightFactor + 8,
          decoration: BoxDecoration(
            color: isToday ? AppColors.primaryPink : AppColors.primaryPink.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: TextStyle(
            color: isToday ? AppColors.primaryPink : AppColors.textGrey,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            fontSize: 10,
          ),
        ),
      ],
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🔥 $_currentStreak dias',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textDark,
                    ),
                  ),
                  const Text(
                    'Sequência atual de foco',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 12),
                  ),
                ],
              ),
              _buildCircleIcon(Icons.emoji_events_outlined, AppColors.primaryPink),
            ],
          ),
          const SizedBox(height: 24),
          _buildContributionGrid(_contributionData),
          const SizedBox(height: 16),
          _buildGridLegend(),
        ],
      ),
    );
  }

  Widget _buildContributionGrid(List<double> contributions) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: contributions.map((intensity) {
        return Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: AppColors.primaryPink.withValues(alpha: intensity > 0 ? intensity.clamp(0.1, 1.0) : 0.05),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSummaryCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _buildCircleIcon(icon, color),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
          Text(label, style: const TextStyle(color: AppColors.textGrey, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildCircleIcon(IconData icon, Color color) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.1),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }

  Widget _buildGridLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text('Menos ', style: TextStyle(color: AppColors.textGrey, fontSize: 10)),
        ...List.generate(3, (i) => Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: AppColors.primaryPink.withValues(alpha: 0.3 * (i + 1)),
            borderRadius: BorderRadius.circular(2),
          ),
        )),
        const Text(' Mais', style: TextStyle(color: AppColors.textGrey, fontSize: 10)),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: AppColors.softShadow,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textGrey,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  bool _isToday(String dayName) {
    final daysMap = {1: 'Seg', 2: 'Ter', 3: 'Qua', 4: 'Qui', 5: 'Sex', 6: 'Sáb', 7: 'Dom'};
    return daysMap[DateTime.now().weekday] == dayName;
  }
}