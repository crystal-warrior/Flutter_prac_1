import 'package:flutter/material.dart';
import '../cubit/fertilizers_cubit.dart';

class AddFertilizerDialog extends StatefulWidget {
  final FertilizersCubit cubit;

  const AddFertilizerDialog({super.key, required this.cubit});

  @override
  State<AddFertilizerDialog> createState() => _AddFertilizerDialogState();
}

class _AddFertilizerDialogState extends State<AddFertilizerDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _applicationController = TextEditingController();
  final _compositionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _applicationController.dispose();
    _compositionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Новое удобрение'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Название удобрения *',
                    hintText: 'Например: Азофоска',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Введите название удобрения';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Описание',
                    hintText: 'Краткое описание удобрения',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _applicationController,
                  decoration: const InputDecoration(
                    labelText: 'Применение',
                    hintText: 'Как и когда применять',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _compositionController,
                  decoration: const InputDecoration(
                    labelText: 'Состав',
                    hintText: 'Химический состав или компоненты',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.cubit.addFertilizer(
                _nameController.text.trim(),
                _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
                _applicationController.text.trim().isEmpty ? null : _applicationController.text.trim(),
                _compositionController.text.trim().isEmpty ? null : _compositionController.text.trim(),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Удобрение добавлено!')),
              );
              Navigator.of(context).pop();
            }
          },
                child: const Text('Сохранить'),
        ),
      ],
    );
  }
}