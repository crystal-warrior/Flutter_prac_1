import 'package:flutter/material.dart';
import '../models/plant_model.dart';
import 'plant_row.dart';

class PlantsTable extends StatelessWidget {
  final List<PlantModel> plants;
  final ValueChanged<String> onRemove;

  const PlantsTable({
    super.key,
    required this.plants,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (plants.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.spa, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Список растений пуст :(',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Нажмите + чтобы добавить растение!',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: plants.length,
      itemBuilder: (context, index) {
        final plant = plants[index];
        return PlantRow(
          key: ValueKey(plant.id),
          plant: plant,
          onRemove: () => onRemove(plant.id),
        );
      },
    );
  }
}