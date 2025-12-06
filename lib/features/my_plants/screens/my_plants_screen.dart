import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jhvostov_prac_1/features/my_plants/screens/add_plant_dialog.dart';
import '../cubit/my_plants_cubit.dart';

class MyPlantsScreen extends StatelessWidget {
  const MyPlantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String imageUrl = "https://avatars.mds.yandex.net/i?id=d610e22a7fdf20c4ca2ea6b37f3340e8e89ba46b-4966461-images-thumbs&n=13";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Растения на полив'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.lightGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Отслеживайте состояние ваших растений и своевременно поливайте их',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Список растений',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: state.plants.isEmpty
                    ? const Center(
                  child: Text(
                    'Растений пока нет.\nНажмите +, чтобы добавить первое!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                )
                    : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.plants.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 20,
                    color: Colors.lightGreen![300],
                  ),
                  itemBuilder: (context, index) {
                    final plant = state.plants[index];
                    return Dismissible(
                      key: ValueKey('myplant_${plant.name}_$index'),
                      direction: DismissDirection.startToEnd,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        context.read<MyPlantsCubit>().removePlant(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Растение удалено!')),
                        );
                      },
                      child: Card(
                        //color: Colors.white,
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          leading: const Icon(Icons.eco, color: Colors.lightGreen),
                          title: Text(plant.name),
                          subtitle: Text('Полив был: ${plant.daysUntilWatering} дней назад'),
                          trailing: Chip(
                            label: Text(plant.health),
                            backgroundColor: plant.healthColor,
                            labelStyle: const TextStyle(color: Colors.white),
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
      // Кнопка добавления в правом нижнем углу
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.white,
        onPressed: () {
          // Получаем cubit из текущего контекста и передаём его в диалог
          final cubit = context.read<MyPlantsCubit>();
          showDialog(
            context: context,
            builder: (context) => AddPlantDialog(cubit: cubit),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}