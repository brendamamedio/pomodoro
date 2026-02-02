import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../services/auth_service.dart';

class AddTaskScreen extends StatefulWidget {
  final String? taskId;
  final String? initialTitle;
  final int? initialPomodoros;

  const AddTaskScreen({
    super.key,
    this.taskId,
    this.initialTitle,
    this.initialPomodoros,
  });

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final AuthService _authService = AuthService();
  late TextEditingController _taskController;
  int _pomodoroCount = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController(text: widget.initialTitle ?? '');
    _pomodoroCount = widget.initialPomodoros ?? 1;
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    final title = _taskController.text.trim();
    if (title.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      await _authService.addTask(title, _pomodoroCount);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e'))
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textGrey),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.taskId == null ? 'Nova Tarefa' : 'Editar Tarefa',
          style: const TextStyle(
            color: AppColors.textDark,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('NOME DA TAREFA', style: _labelStyle),
            const SizedBox(height: 12),
            TextField(
              controller: _taskController,
              autofocus: true,
              decoration: _inputDecoration('Nome da Tarefa'),
            ),
            const SizedBox(height: 32),
            const Text('ESTIMATIVA DE FOCO', style: _labelStyle),
            const SizedBox(height: 12),
            _buildPomodoroSelector(),
            const SizedBox(height: 48),
            _buildSaveButton(),
            if (widget.taskId != null) _buildDeleteButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPomodoroSelector() {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () =>
                setState(() => _pomodoroCount > 1 ? _pomodoroCount-- : null),
            icon: const Icon(Icons.remove, color: AppColors.textGrey),
          ),
          Row(
            children: [
              Text(
                '$_pomodoroCount',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              const Text('🍅', style: TextStyle(fontSize: 20)),
            ],
          ),
          IconButton(
            onPressed: () => setState(() => _pomodoroCount++),
            icon: const Icon(Icons.add, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveTask,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'Salvar Alterações',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Center(
      child: TextButton.icon(
        onPressed: () {
          /* Lógica de deletar */
        },
        icon: const Icon(Icons.delete_outline, color: AppColors.textGrey),
        label: const Text(
          'Excluir Tarefa',
          style: TextStyle(color: AppColors.textGrey),
        ),
      ),
    );
  }

  static const _labelStyle = TextStyle(
    color: AppColors.textGrey,
    fontSize: 12,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
  );

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
    ),
  );
}
