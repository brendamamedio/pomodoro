import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/auth_service.dart';
import '../../../data/models/task_model.dart';
import '../widgets/custom_bottom_nav.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, authService),
              Expanded(
                child: StreamBuilder<List<TaskModel>>(
                  stream: authService.getTasks(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.primaryPink));
                    }

                    final tasks = snapshot.data ?? [];

                    if (tasks.isEmpty) {
                      return const Center(
                        child: Text(
                          "Nenhuma tarefa encontrada",
                          style: TextStyle(color: AppColors.textGrey, fontFamily: 'Poppins'),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return _buildTaskCard(context, tasks[index], authService);
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
        onPressed: () => _showAddTaskDialog(context, authService),
        backgroundColor: AppColors.primaryPink,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }

  Widget _buildHeader(BuildContext context, AuthService authService) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Minhas Tarefas',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 24,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz, color: AppColors.textDark),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, TaskModel task, AuthService service) {
    final bool isDone = task.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDone ? Colors.white.withAlpha(100) : Colors.white.withAlpha(150),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDone ? Colors.transparent : Colors.white.withAlpha(100),
        ),
        boxShadow: isDone ? [] : AppColors.softShadow,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Icon(
          isDone ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isDone ? Colors.green : AppColors.primaryPink,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDone ? AppColors.textGrey : AppColors.textDark,
            fontFamily: 'Poppins',
            decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
            decorationThickness: 2,
            decorationColor: AppColors.textGrey,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              const Text("🍅", style: TextStyle(fontSize: 14)),
              const SizedBox(width: 4),
              Text(
                "${task.completedPomodoros} / ${task.totalPomodoros} pomodoros",
                style: TextStyle(
                  fontSize: 12,
                  color: isDone ? AppColors.textGrey : AppColors.textDark.withAlpha(180),
                  decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
        trailing: isDone
            ? null
            : const Icon(Icons.chevron_right, color: AppColors.textGrey),
        onLongPress: () => _showDeleteConfirm(context, task.id, service),
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, String id, AuthService service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Excluir tarefa?"),
        content: const Text("Esta ação não pode ser desfeita."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          TextButton(
            onPressed: () {
              service.deleteTask(id);
              Navigator.pop(context);
            },
            child: const Text("Excluir", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, AuthService service) {
    final TextEditingController controller = TextEditingController();
    int pomodoros = 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.fromLTRB(24, 32, 24, MediaQuery.of(context).viewInsets.bottom + 32),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Nova Tarefa", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
              const SizedBox(height: 24),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "O que você vai fazer?",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 24),
              const Text("Objetivo de Pomodoros", style: TextStyle(fontSize: 14, color: AppColors.textGrey)),
              Row(
                children: [
                  IconButton(onPressed: () => setModalState(() => pomodoros > 1 ? pomodoros-- : null), icon: const Icon(Icons.remove_circle_outline)),
                  Text("$pomodoros", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () => setModalState(() => pomodoros++), icon: const Icon(Icons.add_circle_outline)),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    service.addTask(controller.text, pomodoros);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPink,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text("CRIAR TAREFA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}