import 'package:flutter/material.dart';
import '../models/plant_model.dart';
import '../widgets/plants_table.dart';

class PlantsScreen extends StatelessWidget {
  final List<PlantModel> plants;
  final double averageComplexity;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  const PlantsScreen({
    super.key,
    required this.plants,
    required this.averageComplexity,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои Растения'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        plants.length.toString(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightGreen,
                        ),
                      ),
                      const Text('Растений в вашем саду'),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        averageComplexity.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightGreen,
                        ),
                      ),
                      const Text('Сложность ухода за вашим садом'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: PlantsTable(
              plants: plants,
              onRemove: onRemove,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAdd,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}