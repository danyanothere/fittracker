import 'package:flutter/material.dart';
import '../widgets/label_value_row.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                  child: Text(
                    'DD',
                    style: TextStyle(fontSize: 28, color: scheme.onPrimaryContainer),
                  ),
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
                ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: const Text('Уведомления'),
                  trailing: Switch(value: true, onChanged: (_) {}),
                ),
                const ListTile(
                  leading: Icon(Icons.straighten),
                  title: Text('Единицы измерения'),
                  trailing: Text('кг, см'),
                ),
                ListTile(
                  leading: Icon(Icons.logout, color: scheme.error),
                  title: Text('Выйти', style: TextStyle(color: scheme.error)),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
