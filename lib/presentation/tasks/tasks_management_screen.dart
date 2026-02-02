import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';
import '../widgets/custom_bottom_nav.dart';
import 'widgets/task_item_card.dart';
import 'widgets/empty_tasks_view.dart';
import '../../services/auth_service.dart';
import '../../data/models/task_model.dart';

class TasksManagementScreen extends StatelessWidget {
  const TasksManagementScreen({super.key});

  AuthService get _authService => AuthService();

  void _navigateToAddTask(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.addTask);
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
                child: StreamBuilder<List<TaskModel>>(
                  stream: _authService.getTasks(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: AppColors.primaryPink),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Erro ao carregar: ${snapshot.error}'));
                    }

                    final tasks = snapshot.data ?? [];

                    if (tasks.isEmpty) {
                      return EmptyTasksView(onAddTask: () => _navigateToAddTask(context));
                    }

                    return ListView.builder(

                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: TaskItemCard(
                            title: task.title,

                            totalPomodoros: task.totalPomodoros,
                            completedPomodoros: task.completedPomodoros,
                            isCompleted: task.isCompleted,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFAB(context),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
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
      onPressed: () => _navigateToAddTask(context),
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