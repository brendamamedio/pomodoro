import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class EmptyTasksView extends StatelessWidget {
  final VoidCallback onAddTask;

  const EmptyTasksView({super.key, required this.onAddTask});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {

        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(
                height: constraints.maxHeight * 0.25,
                child: _buildIllustration(),
              ),
              const SizedBox(height: 32),
              const Text(
                'Sua lista está limpa.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 26,
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
                ),
              ),
              const SizedBox(height: 40),
              _buildAddButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIllustration() {
    return FittedBox(
      fit: BoxFit.contain,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 192,
            height: 192,
            decoration: BoxDecoration(
              color: AppColors.primaryPink.withAlpha(25),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 128,
            height: 160,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(153),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withAlpha(102)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(12),
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
      ),
    );
  }

  Widget _buildMiniTaskRow(int index) {

    int alphaValue = (100 - (index * 25)).clamp(0, 255);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                  color: AppColors.primaryPink.withAlpha(alphaValue),
                  width: 2
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 50,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.primaryPink.withAlpha(alphaValue),
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
              color: AppColors.primaryPink.withAlpha(76),
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