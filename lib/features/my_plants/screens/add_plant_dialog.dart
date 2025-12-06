import 'package:flutter/material.dart';
import '../cubit/my_plants_cubit.dart';

class AddPlantDialog extends StatelessWidget {
  final MyPlantsCubit cubit; // принимаем cubit
  final _nameController = TextEditingController();
  final _daysController = TextEditingController();

  AddPlantDialog({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Новое растение'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Название растения',
              ),
              style: const TextStyle(color: Colors.lightGreen),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _daysController,
              decoration: const InputDecoration(
                labelText: 'Дней до полива',
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.lightGreen),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = _nameController.text.trim();
            final daysStr = _daysController.text.trim();
            if (name.isEmpty || daysStr.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Заполните все поля')),
              );
              return;
            }
            if (int.tryParse(daysStr) == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Введите корректное число дней')),
              );
              return;
            }

            cubit.addPlant(name, daysStr); // используем переданный cubit
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Растение добавлено!')),
            );
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
          child: const Text('Сохранить', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}