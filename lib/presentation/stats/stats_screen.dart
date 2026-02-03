import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/custom_bottom_nav.dart';
import '../../../services/auth_service.dart';
import '../../../data/models/history_model.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: StreamBuilder<List<HistoryModel>>(
            stream: authService.getUserHistory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryPink,
                  ),
                );
              }

              final history = snapshot.data ?? [];

              final int totalMinutes = history
                  .where((h) => h.type == 'focus')
                  .fold(0, (sum, h) => sum + h.durationMinutes);

              final int totalPomodoros = history
                  .where((h) => h.type == 'focus')
                  .length;
              final int streak = _calculateStreak(history);
              final List<double> weeklyData = _getWeeklyData(history);

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 32),
                    _buildSectionTitle('RESUMO TOTAL'),
                    const SizedBox(height: 16),
                    _buildDailySummary(totalMinutes, totalPomodoros),
                    const SizedBox(height: 32),
                    _buildSectionTitle('PRODUTIVIDADE SEMANAL'),
                    const SizedBox(height: 16),
                    _buildWeeklyChart(weeklyData),
                    const SizedBox(height: 32),
                    _buildSectionTitle('SUA SEQUÊNCIA'),
                    const SizedBox(height: 16),
                    _buildStreakCard(streak, history),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
    );
  }

  int _calculateStreak(List<HistoryModel> history) {
    if (history.isEmpty) return 0;

    final focusDates = history
        .where((h) => h.type == 'focus')
        .map(
          (h) => DateTime(
            h.completedAt.year,
            h.completedAt.month,
            h.completedAt.day,
          ),
        )
        .toSet()
        .toList();

    focusDates.sort((a, b) => b.compareTo(a));

    int streak = 0;
    DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    if (focusDates.isEmpty ||
        focusDates.first.isBefore(today.subtract(const Duration(days: 1)))) {
      return 0;
    }

    DateTime currentCheck = focusDates.first;
    for (var date in focusDates) {
      if (date == currentCheck) {
        streak++;
        currentCheck = currentCheck.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  List<double> _getWeeklyData(List<HistoryModel> history) {
    List<double> data = List.filled(7, 0.0);
    DateTime now = DateTime.now();

    for (int i = 0; i < 7; i++) {
      DateTime dateToCheck = now.subtract(Duration(days: 6 - i));
      int dailyMinutes = history
          .where(
            (h) =>
                h.type == 'focus' &&
                h.completedAt.year == dateToCheck.year &&
                h.completedAt.month == dateToCheck.month &&
                h.completedAt.day == dateToCheck.day,
          )
          .fold(0, (sum, h) => sum + h.durationMinutes);

      data[i] = (dailyMinutes / 480).clamp(0.05, 1.0);
    }
    return data;
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
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDailySummary(int totalMinutes, int totalPomodoros) {
    String hours = '${totalMinutes ~/ 60}h ${totalMinutes % 60}m';
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            hours,
            'Tempo Total',
            Icons.access_time_filled,
            AppColors.primaryPink,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            totalPomodoros.toString(),
            'Pomodoros',
            Icons.timer,
            const Color(0xFFB794F4),
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyChart(List<double> weeklyData) {
    final days = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];

    int todayWeekday = DateTime.now().weekday % 7;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              int dayIndex =
                  (DateTime.now().subtract(Duration(days: 6 - index)).weekday) %
                  7;
              return _buildBar(
                weeklyData[index],
                days[dayIndex],
                isToday: index == 6,
              );
            }),
          ),
          const Divider(height: 32, color: Color(0xFFF1F5F9)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  CircleAvatar(
                    radius: 4,
                    backgroundColor: AppColors.primaryPink,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Hoje',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 12),
                  ),
                ],
              ),
              Text(
                'Dados dos últimos 7 dias',
                style: TextStyle(
                  color: AppColors.textGrey.withAlpha(150),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard(int streak, List<HistoryModel> history) {
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
                    '🔥 $streak ${streak == 1 ? "dia" : "dias"}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textDark,
                    ),
                  ),
                  const Text(
                    'Mantenha o ritmo!',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 12),
                  ),
                ],
              ),
              _buildCircleBtn(
                Icons.emoji_events_outlined,
                color: AppColors.primaryPink.withAlpha(51),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildContributionGrid(history),
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
            color: isToday
                ? AppColors.primaryPink
                : AppColors.primaryPink.withAlpha(77),
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

  Widget _buildContributionGrid(List<HistoryModel> history) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: List.generate(21, (index) {
        DateTime date = DateTime.now().subtract(Duration(days: 20 - index));
        int count = history
            .where(
              (h) =>
                  h.type == 'focus' &&
                  h.completedAt.year == date.year &&
                  h.completedAt.month == date.month &&
                  h.completedAt.day == date.day,
            )
            .length;

        double opacity = (count * 0.3).clamp(0.1, 1.0);
        if (count == 0) opacity = 0.05;

        return Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: AppColors.primaryPink.withAlpha((opacity * 255).toInt()),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
              fontFamily: 'Poppins',
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: AppColors.textGrey, fontSize: 11),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white.withAlpha(127),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: Colors.white.withAlpha(102)),
  );

  Widget _buildSectionTitle(String title) => Text(
    title,
    style: const TextStyle(
      color: AppColors.textGrey,
      fontSize: 12,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.4,
    ),
  );

  Widget _buildCircleBtn(IconData icon, {Color? color, VoidCallback? onTap}) =>
      InkWell(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color ?? Colors.white.withAlpha(127),
            border: Border.all(color: Colors.white.withAlpha(102)),
          ),
          child: Icon(icon, size: 20, color: AppColors.textDark),
        ),
      );

  Widget _buildGridLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text(
          'Menos ',
          style: TextStyle(color: AppColors.textGrey, fontSize: 10),
        ),
        ...List.generate(
          3,
          (i) => Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: AppColors.primaryPink.withAlpha(
                (0.3 * (i + 1) * 255).toInt(),
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const Text(
          ' Mais',
          style: TextStyle(color: AppColors.textGrey, fontSize: 10),
        ),
      ],
    );
  }
}
