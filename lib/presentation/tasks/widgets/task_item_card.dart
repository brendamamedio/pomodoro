import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TaskItemCard extends StatelessWidget {
  final String title;
  final String pomodoros;
  final bool isCompleted;

  const TaskItemCard({
    super.key,
    required this.title,
    required this.pomodoros,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isCompleted ? 0.5 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.surfaceWhite.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            _buildCheckBox(),
            const SizedBox(width: 16),
            Expanded(child: _buildTitle()),
            _buildPomodoroBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckBox() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted ? AppColors.primaryPink : Colors.transparent,
        border: Border.all(color: AppColors.primaryPink, width: 2),
      ),
      child: isCompleted ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.textDark,
        fontSize: 15,
        fontWeight: FontWeight.w500,
        decoration: isCompleted ? TextDecoration.lineThrough : null,
      ),
    );
  }

  Widget _buildPomodoroBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isCompleted ? const Color(0x7FE2E8F0) : AppColors.primaryPink.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text('$pomodoros 🍅', style: const TextStyle(fontSize: 12)),
    );
  }
}