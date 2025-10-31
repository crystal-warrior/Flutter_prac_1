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

  void _addPlant(PlantModel newPlant) {
    setState(() {
      _plants.add(newPlant);
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

  void _goBackToMainScreen() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мои Растения'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _goBackToMainScreen,
        ),
      ),
      body: PlantsScreen(
        plants: _plants,
        averageComplexity: _averageComplexity,
        onAdd: _addPlant,
        onRemove: _removePlant,
      ),
    );
  }
}