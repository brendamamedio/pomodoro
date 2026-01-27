import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/custom_bottom_nav.dart';
import 'widgets/task_item_card.dart';
import 'widgets/task_edit_sheet.dart';
import 'widgets/empty_tasks_view.dart';

class TasksManagementScreen extends StatelessWidget {
  const TasksManagementScreen({super.key});

  final bool hasTasks = false;

  void _openEditSheet(BuildContext context, {String? title, int pomodoros = 1, bool isEditing = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TaskEditSheet(
        initialTitle: title,
        initialPomodoros: pomodoros,
        isEditing: isEditing,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: hasTasks
                    ? _buildTaskList(context)
                    : EmptyTasksView(onAddTask: () => _openEditSheet(context)),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: hasTasks ? _buildFAB(context) : null,
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }

  Widget _buildTaskList(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        _buildTaskItem(context, 'Estudar UI Design', 3),
        _buildTaskItem(context, 'Revisar documentação', 2),
        _buildTaskItem(context, 'Exercícios de Logística', 4),
        const TaskItemCard(
            title: 'Planejamento Semanal',
            pomodoros: '1/1',
            isCompleted: true
        ),
        _buildTaskItem(context, 'Ler 10 páginas', 2),
      ],
    );
  }

  Widget _buildTaskItem(BuildContext context, String title, int pomodoros) {
    return InkWell(
      onTap: () => _openEditSheet(
          context,
          title: title,
          pomodoros: pomodoros,
          isEditing: true
      ),
      child: TaskItemCard(title: title, pomodoros: pomodoros.toString()),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
      child: Row(
        children: [
          const Text(
            'Minhas Tarefas',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 24,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          _buildCircleBtn(Icons.more_horiz),
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
        color: Colors.white.withValues(alpha: 0.6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
      ),
      child: Icon(icon, size: 18, color: AppColors.textDark),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _openEditSheet(context),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: AppColors.fabGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPink.withValues(alpha: 0.4),
              blurRadius: 24,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }
}