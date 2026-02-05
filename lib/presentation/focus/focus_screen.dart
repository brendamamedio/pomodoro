import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/custom_bottom_nav.dart';
import '../../controllers/timer_controller.dart';
import '../../services/auth_service.dart';
import '../../data/models/task_model.dart';
import 'widgets/timer_painter.dart';
import '../tasks/widgets/task_selection_sheet.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  final TimerController _controller = TimerController();
  final AuthService _authService = AuthService();
  final String _userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  bool _isSettingsLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    if (_userId.isEmpty) return;

    if (_controller.completedPomodoros == 0) {
      final count = await _authService.getTodayFocusCount();
      _controller.completedPomodoros = count;
    }

    _authService.getUserSettings(_userId).listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;
        final settings = data?['settings'] as Map<String, dynamic>? ?? {};

        _controller.updateSettings(
          focusMin: settings['focusTime'] ?? 25,
          shortMin: settings['shortBreak'] ?? 5,
          longMin: settings['longBreak'] ?? 15,
          interval: settings['longBreakInterval'] ?? 4,
        );

        if (mounted && !_isSettingsLoaded) {
          setState(() => _isSettingsLoaded = true);
        }
      }
    });
  }

  void _showFinishConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Finalizar Sessão?"),
        content: const Text("Deseja encerrar este ciclo agora? O progresso será registrado no seu histórico e a tarefa será marcada como concluída."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCELAR", style: TextStyle(color: AppColors.textGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F172A),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              Navigator.pop(context);
              await _controller.finishSession(_authService);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sessão finalizada com sucesso!')),
                );
              }
            },
            child: const Text("FINALIZAR", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showTaskSelection(BuildContext context) async {
    final result = await showModalBottomSheet<TaskModel>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const TaskSelectionSheet(),
    );

    if (result != null) {
      _controller.selectedTask = result;
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
          child: !_isSettingsLoaded
              ? const Center(child: CircularProgressIndicator(color: AppColors.primaryPink))
              : ListenableBuilder(
            listenable: _controller,
            builder: (context, child) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    _buildTimerSection(),
                    const SizedBox(height: 48),
                    _buildTaskSelector(context),
                    _buildActionButtons(),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
    );
  }

  Widget _buildTimerSection() {
    bool isFocus = _controller.currentMode == TimerMode.focus;
    Color themeColor = isFocus ? AppColors.primaryPink : Colors.green;

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
                border: Border.all(color: themeColor.withValues(alpha: 0.1)),
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
                    child: CustomPaint(painter: TimerPainter(progress: _controller.progress)),
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
                      Text(
                        isFocus ? "MODO DE FOCO" : "MODO DE PAUSA",
                        style: TextStyle(
                          fontSize: 12,
                          color: themeColor,
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
        Text(
          isFocus ? "Hora de Focar" : "Hora de Relaxar",
          style: const TextStyle(fontSize: 30, color: AppColors.textDark, fontFamily: 'Poppins'),
        ),
      ],
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
        child: Row(
          children: [
            const Icon(Icons.assignment_outlined, size: 18, color: AppColors.primaryPink),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _controller.selectedTask?.title ?? "Selecione a tarefa ativa",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFF334155), fontWeight: FontWeight.w500),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF334155)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final bool hasTask = _controller.selectedTask != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              if (!hasTask) {
                _showTaskWarning();
                return;
              }
              _controller.isRunning ? _controller.stopTimer() : _controller.startTimer();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: hasTask ? const Color(0xFF0F172A) : Colors.grey.shade400,
              minimumSize: const Size(double.infinity, 64),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
              elevation: hasTask ? 2 : 0,
            ),
            child: Text(
              !hasTask ? "SELECIONE UMA TAREFA" : (_controller.isRunning ? "PAUSAR" : "INICIAR SESSÃO"),
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSecondaryBtn(
                  "Reiniciar",
                  onTap: hasTask ? _controller.resetTimer : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSecondaryBtn(
                  "Finalizar",
                  onTap: hasTask ? _showFinishConfirmation : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showTaskWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Selecione uma tarefa na lista abaixo para começar!"),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
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
            style: TextStyle(
              color: onTap == null ? Colors.grey : const Color(0xFF334155),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}