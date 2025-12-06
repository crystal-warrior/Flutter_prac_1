import 'package:flutter/material.dart';
import '../cubit/fertilizers_cubit.dart';

class AddFertilizerDialog extends StatelessWidget {
  final FertilizersCubit cubit; // принимаем cubit
  final _controller = TextEditingController();

  AddFertilizerDialog({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Новое удобрение'),
      content: SizedBox(
        width: double.maxFinite,
        child: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Название и вес',
            hintText: 'Например: Азофоска, 1 кг',
          ),
          style: const TextStyle(color: Colors.lightGreen),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = _controller.text.trim();
            if (name.isNotEmpty) {
              cubit.addFertilizer(name); // спользуем переданный cubit
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Удобрение добавлено!')),
              );
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Введите название удобрения')),
              );
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
          child: const Text('Сохранить', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}