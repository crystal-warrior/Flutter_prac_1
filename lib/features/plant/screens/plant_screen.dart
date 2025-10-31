import 'package:flutter/material.dart';
import '../models/plant_model.dart';
import '../widgets/plants_table.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'plant_form_screen.dart';

class PlantsScreen extends StatelessWidget {
  final String _imageUrl = "https://static.vecteezy.com/system/resources/previews/001/500/436/large_2x/many-plants-in-greenhouse-with-glass-wall-on-white-background-free-vector.jpg";

  final List<PlantModel> plants;
  final double averageComplexity;
  final Function(PlantModel) onAdd;
  final ValueChanged<String> onRemove;

  const PlantsScreen({
    super.key,
    required this.plants,
    required this.averageComplexity,
    required this.onAdd,
    required this.onRemove,
  });


  void _navigateToAddPlant(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlantFormScreen(
          onSave: (String name, String type, int careComplexity) {

            final newPlant = PlantModel(
              id: DateTime.now().microsecondsSinceEpoch.toString(),
              name: name,
              type: type,
              careComplexity: careComplexity,
            );

            onAdd(newPlant);

            Navigator.pop(context);
          },
          onCancel: () {

            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои Растения'),
      ),
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
        onPressed: () => _navigateToAddPlant(context),
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