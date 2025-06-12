import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/user_type.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/rastreia_logo.dart';
import '../../features/auth/verification_page.dart';

class RegisterPage extends StatefulWidget {
  final UserType userType;

  const RegisterPage({
    Key? key,
    required this.userType,
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _matriculaController = TextEditingController();
  final _unidadeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nomeController.dispose();
    _cpfController.dispose();
    _matriculaController.dispose();
    _unidadeController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.startRegistration(
        _emailController.text,
        _passwordController.text,
        name: _nomeController.text,
        cpf: _cpfController.text,
        userType: widget.userType,
        matricula: widget.userType == UserType.policial
            ? _matriculaController.text
            : null,
        unidade: widget.userType == UserType.policial
            ? _unidadeController.text
            : null,
      );

      if (mounted) {
        if (success) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => VerificationPage(
                email: _emailController.text,
                password: _passwordController.text,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro ao iniciar registro. Tente novamente.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Conta - ${widget.userType.label}'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _nomeController,
                label: 'Nome Completo',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite seu nome completo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _cpfController,
                label: 'CPF',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite seu CPF';
                  }
                  if (value.length != 11) {
                    return 'CPF inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (widget.userType == UserType.policial) ...[
                CustomTextField(
                  controller: _matriculaController,
                  label: 'Matrícula Policial',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite sua matrícula';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _unidadeController,
                  label: 'Unidade/Delegacia',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite sua unidade/delegacia';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],
              CustomTextField(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite seu email';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Digite um email válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                label: 'Senha',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite sua senha';
                  }
                  if (value.length < 6) {
                    return 'A senha deve ter pelo menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _confirmPasswordController,
                label: 'Confirmar Senha',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirme sua senha';
                  }
                  if (value != _passwordController.text) {
                    return 'As senhas não coincidem';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              CustomButton(
                onPressed: _isLoading ? null : _register,
                text: _isLoading ? 'Criando conta...' : 'Criar Conta',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
