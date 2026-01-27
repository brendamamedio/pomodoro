import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/task_item_card.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.bgGradient,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      children: const [
                        TaskItemCard(title: 'Estudar UI Design', pomodoros: '3'),
                        TaskItemCard(title: 'Revisar documentação', pomodoros: '2'),
                        TaskItemCard(title: 'Exercícios de Logística', pomodoros: '4'),
                        TaskItemCard(
                            title: 'Planejamento Semanal',
                            pomodoros: '1/1',
                            isCompleted: true
                        ),
                        TaskItemCard(title: 'Ler 10 páginas', pomodoros: '2'),
                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
              _buildFloatingActionButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
      child: Row(
        children: [
          _buildCircleBtn(Icons.arrow_back_ios_new),
          const SizedBox(width: 24),
          const Text(
            'Minhas Tarefas',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 24,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleBtn(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha:0.6),
        border: Border.all(color: Colors.white.withValues(alpha:0.4)),
      ),
      child: Icon(icon, size: 18, color: AppColors.textDark),
    );
  }

  Widget _buildFloatingActionButton() {
    return Positioned(
      right: 24,
      bottom: 24,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: AppColors.fabGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPink.withValues(alpha:0.4),
              blurRadius: 24,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavIcon(Icons.timer_rounded, "FOCO", false),
          _NavIcon(Icons.list_alt_rounded, "TAREFAS", true),
          _NavIcon(Icons.bar_chart_rounded, "STATUS", false),
          _NavIcon(Icons.settings_outlined, "AJUSTES", false),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  const _NavIcon(this.icon, this.label, this.active);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: active ? const Color(0xFFEC6888) : AppColors.textGrey),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: active ? const Color(0xFFEC6888) : AppColors.textGrey,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}