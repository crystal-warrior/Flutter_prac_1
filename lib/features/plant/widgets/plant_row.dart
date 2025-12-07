import 'package:flutter/material.dart';
import '../../../../core/models/plant.dart';

class PlantRow extends StatelessWidget {
  final Plant plant;
  final VoidCallback onRemove;

  const PlantRow({
    super.key,
    required this.plant,
    required this.onRemove,
  });

  Color _getComplexityColor(int complexity) {
    if (complexity <= 3) return Colors.lightGreen;
    if (complexity <= 6) return Colors.amber;
    return Colors.red;
  }

  String _getComplexityText(int complexity) {
    if (complexity <= 3) return 'Легкий';
    if (complexity <= 6) return 'Средний';
    return 'Сложный';
  }

  IconData _getPlantIcon(String type) {
    switch (type.toLowerCase()) {
      case 'деревья':
        return Icons.apple;
      case 'однолетники':
        return Icons.local_florist;
      case 'травянистые многолетники':
        return Icons.grass;
      case 'овощи':
        return Icons.eco;
      case 'кустарники':
        return Icons.agriculture;
      default:
        return Icons.help;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(
            _getPlantIcon(plant.type),
          ),
        ),
        title: Text(
          plant.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Тип: ${plant.type}'),
            const SizedBox(height: 4),
            Row(
              children: [
                ...List.generate(5, (index) {
                  return Icon(
                    index < (plant.careComplexity / 2).ceil()
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  );
                }),
                const SizedBox(width: 8),
                Text(
                  '${plant.careComplexity}/10',
                  style: TextStyle(
                    color: _getComplexityColor(plant.careComplexity),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _getComplexityText(plant.careComplexity),
                  style: TextStyle(
                    color: _getComplexityColor(plant.careComplexity),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onRemove,
        ),
      ),
    );
  }
}