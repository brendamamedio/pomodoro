import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TaskItemCard extends StatelessWidget {
  final String title;
  final int totalPomodoros;
  final int completedPomodoros;
  final bool isCompleted;
  final VoidCallback? onToggle;

  const TaskItemCard({
    super.key,
    required this.title,
    required this.totalPomodoros,
    required this.completedPomodoros,
    this.isCompleted = false,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        boxShadow: AppColors.softShadow,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onToggle,
            child: _buildCheckbox(),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: isCompleted ? AppColors.textGrey : AppColors.textDark,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text('🍅', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Text(
                      '$completedPomodoros / $totalPomodoros pomodoros',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textGrey,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textGrey, size: 20),
        ],
      ),
    );
  }

  Widget _buildCheckbox() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCompleted ? AppColors.primaryPink : const Color(0xFFE2E8F0),
          width: 2,
        ),
        color: isCompleted ? AppColors.primaryPink : Colors.transparent,
      ),
      child: isCompleted
          ? const Icon(Icons.check, size: 16, color: Colors.white)
          : null,
    );
  }
}