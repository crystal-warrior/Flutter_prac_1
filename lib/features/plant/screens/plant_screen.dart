import 'package:flutter/material.dart';
import '../models/plant_model.dart';
import '../widgets/plants_table.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PlantsScreen extends StatelessWidget {


  final String _imageUrl = "https://static.vecteezy.com/system/resources/previews/001/500/436/large_2x/many-plants-in-greenhouse-with-glass-wall-on-white-background-free-vector.jpg";


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
          Center(
            child:
            SizedBox(
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