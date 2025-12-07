import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jhvostov_prac_1/features/my_plants/screens/add_plant_dialog.dart';
import '../cubit/my_plants_cubit.dart';

class MyPlantsScreen extends StatefulWidget {
  const MyPlantsScreen({super.key});

  @override
  State<MyPlantsScreen> createState() => _MyPlantsScreenState();
}

class _MyPlantsScreenState extends State<MyPlantsScreen> {
  Timer? _updateTimer;
  DateTime? _lastUpdateDate;

  @override
  void initState() {
    super.initState();
    _lastUpdateDate = DateTime.now();
    // Обновляем дни до полива каждую минуту
    _updateTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      final now = DateTime.now();
      // Проверяем, изменился ли день
      if (_lastUpdateDate != null && 
          now.day != _lastUpdateDate!.day ||
          now.month != _lastUpdateDate!.month ||
          now.year != _lastUpdateDate!.year) {
        // Если день изменился, обновляем состояние
        if (mounted) {
          context.read<MyPlantsCubit>().updateDaysUntilWatering();
          _lastUpdateDate = now;
        }
      }
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Проверяем, изменился ли день при каждом build
    final now = DateTime.now();
    if (_lastUpdateDate != null && 
        (now.day != _lastUpdateDate!.day ||
         now.month != _lastUpdateDate!.month ||
         now.year != _lastUpdateDate!.year)) {
      // Если день изменился, обновляем состояние
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<MyPlantsCubit>().updateDaysUntilWatering();
        _lastUpdateDate = now;
      });
    }
    final String imageUrl = "https://avatars.mds.yandex.net/i?id=d610e22a7fdf20c4ca2ea6b37f3340e8e89ba46b-4966461-images-thumbs&n=13";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Растения на полив'),
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final imageSize = constraints.maxWidth * 0.5;
                    return SizedBox(
                      width: imageSize,
                      height: imageSize,
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
                    );
                  },
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
                    color: Theme.of(context).dividerColor,
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
                          leading: Icon(Icons.eco, color: Theme.of(context).colorScheme.primary),
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