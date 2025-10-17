import 'package:flutter/material.dart';
import '../models/plant_model.dart';
import '../screens/plant_screen.dart';
import '../screens/plant_form_screen.dart';

enum Screen { list, form }

class PlantsContainer extends StatefulWidget {
  const PlantsContainer({super.key});

  @override
  State<PlantsContainer> createState() => _PlantsContainerState();
}

class _PlantsContainerState extends State<PlantsContainer> {
  final List<PlantModel> _plants = [];
  Screen _currentScreen = Screen.list;
  PlantModel? _recentlyRemovedPlant;

  double get _averageComplexity {
    if (_plants.isEmpty) return 0;
    final sum = _plants.map((p) => p.careComplexity).reduce((a, b) => a + b);
    return sum / _plants.length;
  }

  void _showList() {
    setState(() => _currentScreen = Screen.list);
  }

  void _showForm() {
    setState(() => _currentScreen = Screen.form);
  }

  void _addPlant(String name, String type, int careComplexity) {
    final newPlant = PlantModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      type: type,
      careComplexity: careComplexity,
    );

    setState(() {
      _plants.add(newPlant);
      _showList();
    });
  }

  void _removePlant(String id) {
    final index = _plants.indexWhere((p) => p.id == id);
    if (index == -1) return;

    _recentlyRemovedPlant = _plants[index];

    setState(() {
      _plants.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Растение "${_recentlyRemovedPlant!.name}" удалено'),
        action: SnackBarAction(
          label: 'Отменить',
          onPressed: _undoRemove,
        ),
      ),
    );
  }

  void _undoRemove() {
    if (_recentlyRemovedPlant != null) {
      setState(() {
        _plants.add(_recentlyRemovedPlant!);
        _recentlyRemovedPlant = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body = _currentScreen == Screen.list
        ? PlantsScreen(
      plants: _plants,
      averageComplexity: _averageComplexity,
      onAdd: _showForm,
      onRemove: _removePlant,
    )
        : PlantFormScreen(
      onSave: _addPlant,
      onCancel: _showList,
    );

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: body,
      ),
    );
  }
}