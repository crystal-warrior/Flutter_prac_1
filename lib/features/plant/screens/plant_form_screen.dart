import 'package:flutter/material.dart';

class PlantFormScreen extends StatefulWidget {
  final void Function(String name, String type, int careComplexity) onSave;
  final VoidCallback onCancel;

  const PlantFormScreen({
    super.key,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<PlantFormScreen> createState() => _PlantFormScreenState();
}

class _PlantFormScreenState extends State<PlantFormScreen> {
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  int _careComplexity = 5;

  final List<String> _plantTypes = [
    'Травянистые многолетники',
    'Деревья',
    'Кустарники',
    'Однолетники',
    'Овощи',
  ];

  void _submit() {
    final name = _nameController.text.trim();
    final type = _typeController.text.trim();

    if (name.isEmpty || type.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все поля')),
      );
      return;
    }

    widget.onSave(name, type, _careComplexity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить растение'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onCancel,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _submit,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Название растения',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _typeController.text.isEmpty ? null : _typeController.text,
              decoration: const InputDecoration(
                labelText: 'Тип растения',
                border: OutlineInputBorder(),
              ),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.lightGreen),
              items: _plantTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(
                    type,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _typeController.text = newValue!;
                });
              },
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Сложность ухода за растением',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('$_careComplexity/10'),
                    const SizedBox(width: 16),
                    ...List.generate(5, (index) {
                      return Icon(
                        index < (_careComplexity / 2).ceil()
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 20,
                      );
                    }),
                  ],
                ),
                Slider(
                  value: _careComplexity.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: '$_careComplexity',
                  onChanged: (double value) {
                    setState(() {
                      _careComplexity = value.round();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Добавить растение'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onCancel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Отмена'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    super.dispose();
  }
}