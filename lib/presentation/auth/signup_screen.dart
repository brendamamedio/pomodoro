import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _userController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.bgGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                const Text(
                  'Criar uma conta',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 30,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 40),
                _buildLabel('Nome de usuário'),
                _buildTextField(
                  controller: _userController,
                  hint: 'Insira seu nome de usuário',
                ),
                const SizedBox(height: 24),
                _buildLabel('E-mail'),
                _buildTextField(
                  controller: _emailController,
                  hint: 'Insira seu e-mail',
                ),
                const SizedBox(height: 24),
                _buildLabel('Senha'),
                _buildTextField(
                  controller: _passwordController,
                  hint: 'Insira sua senha',
                  isPassword: true,
                  obscureText: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.textGrey,
                    ),
                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                ),
                const SizedBox(height: 24),
                _buildTermsCheckbox(),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _acceptTerms ? () {} : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    minimumSize: const Size(double.infinity, 64),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Criar conta',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 60),
                _buildLoginLink(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(color: AppColors.textDark, fontSize: 14, fontFamily: 'Poppins'),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD8DADC)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          border: InputBorder.none,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: (value) => setState(() => _acceptTerms = value!),
          activeColor: AppColors.primaryPink,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        const Expanded(
          child: Text(
            'Aceito os termos e política de privacidade',
            style: TextStyle(color: AppColors.textDark, fontSize: 14, fontFamily: 'Poppins'),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, AppRoutes.login),
        child: Text.rich(
          TextSpan(
            text: 'Já tem uma conta? ',
            style: const TextStyle(color: AppColors.textGrey, fontSize: 14),
            children: [
              TextSpan(
                text: 'Fazer login',
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}