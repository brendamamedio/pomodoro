import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class EmptyTasksView extends StatelessWidget {
  final VoidCallback onAddTask;

  const EmptyTasksView({super.key, required this.onAddTask});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIllustration(),
            const SizedBox(height: 32),
            const Text(
              'Sua lista está limpa.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 30,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Que tal planejar seu próximo\nfoco?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 48),
            _buildAddButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 192,
          height: 192,
          decoration: BoxDecoration(
            color: AppColors.primaryPink.withValues(alpha:0.1),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 128,
          height: 160,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha:0.6),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha:0.4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:0.05),
                blurRadius: 25,
                offset: const Offset(0, 20),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) => _buildMiniTaskRow(index)),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniTaskRow(int index) {
    double opacity = 0.4 - (index * 0.1);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.primaryPink.withValues(alpha:opacity), width: 2),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 50,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.primaryPink.withValues(alpha:opacity),
              borderRadius: BorderRadius.circular(9999),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: onAddTask,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: AppColors.fabGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPink.withValues(alpha:0.3),
              blurRadius: 15,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }
}