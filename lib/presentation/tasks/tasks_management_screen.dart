import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../services/auth_service.dart';
import '../../data/models/task_model.dart';
import '../widgets/custom_bottom_nav.dart';
import 'widgets/task_item_card.dart';
import 'add_task_screen.dart';

class TasksManagementScreen extends StatefulWidget {
  const TasksManagementScreen({super.key});

  @override
  State<TasksManagementScreen> createState() => _TasksManagementScreenState();
}

class _TasksManagementScreenState extends State<TasksManagementScreen> {
  final AuthService _authService = AuthService();

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

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return _buildEmptyState();
                    }

                    final tasks = snapshot.data!;

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddTaskScreen(
                                    taskId: task.id,
                                    initialTitle: task.title,
                                    initialPomodoros: task.totalPomodoros,
                                  ),
                                ),
                              );
                            },
                            child: TaskItemCard(
                              title: task.title,
                              totalPomodoros: task.totalPomodoros,
                              completedPomodoros: task.completedPomodoros,
                              isCompleted: task.isCompleted,
                              onToggle: () {
                                _authService.toggleTaskCompletion(task.id, task.isCompleted);
                              },
                            ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
        },
        backgroundColor: AppColors.textDark,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Text(
        'Minhas Tarefas',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 64, color: AppColors.textGrey.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          const Text(
            'Nenhuma tarefa por aqui',
            style: TextStyle(
              color: AppColors.textGrey,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}