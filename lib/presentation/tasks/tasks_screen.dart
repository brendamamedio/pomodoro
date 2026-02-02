import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';
import '../widgets/custom_bottom_nav.dart';
import 'widgets/task_item_card.dart';
import 'widgets/empty_tasks_view.dart';
import '../../services/auth_service.dart';
import '../../data/models/task_model.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final AuthService _authService = AuthService();


  void _navigateToAddTask() {
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
              _buildHeader(),
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
                      return Center(child: Text('Erro ao carregar dados: ${snapshot.error}'));
                    }

                    final tasks = snapshot.data ?? [];

                    if (tasks.isEmpty) {
                      return EmptyTasksView(onAddTask: _navigateToAddTask);
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 80),
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
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: _buildCircleBtn(Icons.arrow_back_ios_new),
          ),
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
        color: Colors.white.withAlpha(153),
        border: Border.all(color: Colors.white.withAlpha(102)),
      ),
      child: Icon(icon, size: 18, color: AppColors.textDark),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _navigateToAddTask,
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: AppColors.fabGradient,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }
}