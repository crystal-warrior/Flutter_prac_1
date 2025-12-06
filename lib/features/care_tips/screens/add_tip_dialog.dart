import 'package:flutter/material.dart';
import 'package:jhvostov_prac_1/features/care_tips/cubit/care_tips_cubit.dart';

class AddTipDialog extends StatelessWidget {
  final CareTipsCubit cubit; // принимаем Cubit как параметр
  final _titleController = TextEditingController();
  final _tipController = TextEditingController();

   AddTipDialog({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Новый совет по уходу'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Заголовок',
              ),
              style: const TextStyle(color: Colors.lightGreen),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tipController,
              decoration: const InputDecoration(
                labelText: 'Текст совета',
              ),
              maxLines: 3,
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
            final title = _titleController.text.trim();
            final tip = _tipController.text.trim();
            if (title.isNotEmpty && tip.isNotEmpty) {
              cubit.addTip(title, tip); // используем переданный cubit
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Совет добавлен!')),
              );
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Заполните все поля')),
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