import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../data/mock_exercise_repository.dart';
import '../data/mock_session_repository.dart';
import '../widgets/label_value_row.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _simulateError = false; // эфемерное состояние -> setState (C7)

  void _toggleError(bool value) {
    setState(() => _simulateError = value);
    // единственное место UI, которому позволено знать о mock-е
    context.read<MockExerciseRepository>().simulateError = value;
    context.read<MockSessionRepository>().simulateError = value;
  }

  Future<void> _logout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Выйти из аккаунта?'),
        content: const Text('Придётся войти заново.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Нет'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: const Text('Да, выйти'),
          ),
        ],
      ),
    );
    if (ok == true && mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: scheme.primaryContainer,
                  child: Text('DD',
                      style: TextStyle(fontSize: 28, color: scheme.onPrimaryContainer)),
                ),
                const SizedBox(height: 12),
                Text('Daniil Driga', style: Theme.of(context).textTheme.titleLarge),
                Text('Футбол · любитель', style: TextStyle(color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: const [
                  LabelValueRow(label: 'Возраст', value: '20 лет'),
                  LabelValueRow(label: 'Рост', value: '182 см'),
                  LabelValueRow(label: 'Вес', value: '76 кг'),
                  LabelValueRow(label: 'Цель', value: 'Набор силы'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.cloud_off),
                  title: const Text('Симулировать сбой сети'),
                  value: _simulateError,
                  onChanged: _toggleError,
                ),
                ListTile(
                  leading: Icon(Icons.logout, color: scheme.error),
                  title: Text('Выйти', style: TextStyle(color: scheme.error)),
                  onTap: _logout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
