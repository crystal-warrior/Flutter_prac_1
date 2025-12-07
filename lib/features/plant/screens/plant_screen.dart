import 'package:flutter/material.dart';
import '../../../../core/models/plant.dart';
import '../widgets/plants_table.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

class PlantsScreen extends StatelessWidget {
  final String _imageUrl = "https://static.vecteezy.com/system/resources/previews/001/500/436/large_2x/many-plants-in-greenhouse-with-glass-wall-on-white-background-free-vector.jpg";

  final List<Plant> plants;
  final double averageComplexity;
  final Function(Plant) onAdd;
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
      body: Column(
        children: [
          Center(
            child: SizedBox(
              width: 210,
              height: 210,
              child: CachedNetworkImage(
                imageUrl: _imageUrl,
                progressIndicatorBuilder: (context, url, progress) =>
                const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 50,
                  ),
                ),
                fit: BoxFit.contain,
              ),
            ),
          ),
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
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text('Растений в вашем саду'),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        averageComplexity.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const Text('Сложность ухода за вашим садом'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          ElevatedButton(
            onPressed: () {
              context.push('/plant_form');
            },
            child: const Text('Добавить растение'),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: plants.isEmpty
                ? _buildEmptyState()
                : PlantsTable(
              plants: plants,
              onRemove: onRemove,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/plant_form');
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.eco,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'Список растений пуст',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Нажмите + чтобы добавить растение!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}