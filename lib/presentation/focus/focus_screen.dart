import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/custom_bottom_nav.dart';
import '../../controllers/timer_controller.dart';
import 'widgets/timer_painter.dart';
import '../tasks/widgets/task_selection_sheet.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  final TimerController _controller = TimerController();

  void _showTaskSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const TaskSelectionSheet(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ValueListenableBuilder<int>(
              valueListenable: _controller,
              builder: (context, seconds, child) {
                return Column(
                  children: [
                    const SizedBox(height: 40),
                    _buildTimerSection(),
                    const SizedBox(height: 48),
                    _buildTaskSelector(context),
                    _buildActionButtons(),
                    const SizedBox(height: 40),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
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
                border: Border.all(color: AppColors.primaryPink.withValues(alpha: 0.1)),
              ),
            ),
            Container(
              width: 288,
              height: 288,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.4),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: AppColors.softShadow,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 280,
                    height: 280,
                    child: CustomPaint(
                      painter: TimerPainter(progress: _controller.progress),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _controller.timerString,
                        style: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.w300,
                          color: AppColors.textDark,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const Text(
                        "MODO DE FOCO",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textGrey,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w500,
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
          "Hora de Focar",
          style: TextStyle(fontSize: 30, color: AppColors.textDark, fontFamily: 'Poppins'),
        ),
        const SizedBox(height: 12),
        _buildDotIndicator(),
      ],
    );
  }

  Widget _buildDotIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        4,
            (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: index == 0 ? AppColors.primaryPink : const Color(0xFFE2E8F0),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildTaskSelector(BuildContext context) {
    return InkWell(
      onTap: () => _showTaskSelection(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Row(
          children: [
            Icon(Icons.assignment_outlined, size: 18, color: AppColors.primaryPink),
            SizedBox(width: 12),
            Text(
              "Selecione a tarefa ativa",
              style: TextStyle(color: Color(0xFF334155), fontWeight: FontWeight.w500),
            ),
            Spacer(),
            Icon(Icons.chevron_right, color: Color(0xFF334155)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _controller.isRunning ? _controller.stopTimer : _controller.startTimer,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F172A),
              minimumSize: const Size(double.infinity, 64),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            ),
            child: Text(
              _controller.isRunning ? "PAUSAR" : "INICIAR SESSÃO",
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildSecondaryBtn("Reiniciar", onTap: _controller.resetTimer)),
              const SizedBox(width: 16),
              Expanded(child: _buildSecondaryBtn("Finalizar")),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryBtn(String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFF334155), fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}