import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/user_type.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/rastreia_logo.dart';
import 'register_page.dart';

class ProfileSelectionPage extends StatelessWidget {
  const ProfileSelectionPage({Key? key}) : super(key: key);

  void _navigateToRegister(BuildContext context, UserType type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegisterPage(userType: type),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const Center(
                child: RastreiaLogo(size: 48),
              ),
              const SizedBox(height: 60),
              Text(
                'Selecione seu perfil',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              for (final type in UserType.values) ...[
                _ProfileCard(
                  type: type,
                  onTap: () => _navigateToRegister(context, type),
                ),
                const SizedBox(height: 16),
              ],
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Já tenho uma conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final UserType type;
  final VoidCallback onTap;

  const _ProfileCard({
    Key? key,
    required this.type,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  type.icon,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type.label,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      type.description,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
