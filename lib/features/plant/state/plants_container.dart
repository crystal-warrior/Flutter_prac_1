import 'package:flutter/material.dart';
import 'package:jhvostov_prac_1/features/plant/screens/plant_screen.dart';
import '../../../../core/models/plant.dart';

enum Screen { list, form }

class PlantsContainer extends StatefulWidget {
  const PlantsContainer({super.key});

  @override
  State<PlantsContainer> createState() => _PlantsContainerState();
}

class _PlantsContainerState extends State<PlantsContainer> {
  final List<Plant> _plants = [];
  Plant? _recentlyRemovedPlant;

  double get _averageComplexity {
    if (_plants.isEmpty) return 0;
    final sum = _plants.map((p) => p.careComplexity).reduce((a, b) => a + b);
    return sum / _plants.length;
  }

  void _addPlant(Plant newPlant) {
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

  @override
  Widget build(BuildContext context) {
    return PlantsScreen(
      plants: _plants,
      averageComplexity: _averageComplexity,
      onAdd: _addPlant,
      onRemove: _removePlant,
    );
  }
}