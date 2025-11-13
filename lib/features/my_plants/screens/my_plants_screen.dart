
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../cubit/my_plants_cubit.dart';

class MyPlantsScreen extends StatelessWidget {
  const MyPlantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _nameController = TextEditingController();
    final _daysController = TextEditingController();

    final String imageUrl = "https://avatars.mds.yandex.net/i?id=d610e22a7fdf20c4ca2ea6b37f3340e8e89ba46b-4966461-images-thumbs&n=13";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Состояние растений'),
        backgroundColor: Colors.lightGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<MyPlantsCubit, MyPlantsState>(
        builder: (context, state) {
          return Column(
            children: [
              Center(
                child: SizedBox(
                  width: 210,
                  height: 210,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    progressIndicatorBuilder: (context, url, progress) =>
                    const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 50,
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'Добавить растение',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Название растения',
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.lightGreen, width: 2.0),
                          ),
                          labelStyle: const TextStyle(color: Colors.lightGreen),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _daysController,
                        decoration: InputDecoration(
                          labelText: 'Дней до полива',
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.lightGreen, width: 2.0),
                          ),
                          labelStyle: const TextStyle(color: Colors.lightGreen),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          final name = _nameController.text;
                          final days = _daysController.text;
                          if (name.trim().isNotEmpty && days.trim().isNotEmpty) {
                            context.read<MyPlantsCubit>().addPlant(name, days);
                            _nameController.clear();
                            _daysController.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Растение добавлено!')),
                            );
                          }
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Добавить'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Ваши растения:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: state.plants.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 20,
                    color: Colors.lightGreen[300],
                  ),
                  itemBuilder: (context, index) {
                    final plant = state.plants[index];
                    return GestureDetector(
                      key: ValueKey('myplant_${plant.name}_$index'),
                      onTap: () {
                        context.read<MyPlantsCubit>().removePlant(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Растение удалено!')),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          leading: const Icon(Icons.eco, color: Colors.lightGreen),
                          title: Text(plant.name),
                          subtitle: Text('Полив через: ${plant.daysUntilWatering} дней'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Chip(
                                label: Text(plant.health),
                                backgroundColor: plant.healthColor,
                                labelStyle: const TextStyle(color: Colors.black),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.delete_outline, color: Colors.red),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}