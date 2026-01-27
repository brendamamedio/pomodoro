import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TaskEditSheet extends StatelessWidget {
  final String? initialTitle;
  final int initialPomodoros;
  final bool isEditing;

  const TaskEditSheet({
    super.key,
    this.initialTitle,
    this.initialPomodoros = 1,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 32),
          _buildInputField(),
          const SizedBox(height: 24),
          _buildPomodoroSelector(),
          const SizedBox(height: 32),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          isEditing ? 'Editar Tarefa' : 'Nova Tarefa',
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 24,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: AppColors.textDark),
        ),
      ],
    );
  }

  Widget _buildInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'NOME DA TAREFA',
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 10,
            fontStyle: FontStyle.italic,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9).withValues(alpha:0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: TextEditingController(text: initialTitle),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Ex: Estudar Flutter',
              hintStyle: TextStyle(color: AppColors.textGrey),
            ),
            style: const TextStyle(
              color: Color(0xFF334155),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPomodoroSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ESTIMATIVA DE FOCO',
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 10,
            fontStyle: FontStyle.italic,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.textGrey),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRoundBtn(Icons.remove),
              Row(
                children: [
                  Text(
                    '$initialPomodoros',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('🍅', style: TextStyle(fontSize: 20)),
                ],
              ),
              _buildRoundBtn(Icons.add),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoundBtn(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: AppColors.textDark, size: 20),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F172A),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: Text(
              isEditing ? 'Salvar Alterações' : 'Criar Tarefa',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        if (isEditing) ...[
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.delete_outline, color: AppColors.textGrey, size: 20),
            label: const Text(
              'Excluir Tarefa',
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}