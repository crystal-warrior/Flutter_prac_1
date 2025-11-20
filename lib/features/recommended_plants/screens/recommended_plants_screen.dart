import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jhvostov_prac_1/features/authorization/cubit/auth_cubit.dart';
import '../cubit/recommended_plants_cubit.dart';

class RecommendedPlantsScreen extends StatelessWidget {
  const RecommendedPlantsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final userRegion = context.read<AuthCubit>().state.user?.region;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Рекомендуемые растения'),
        backgroundColor: Colors.lightGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocProvider(
        create: (context) => RecommendedPlantsCubit()..loadPlantsForUserRegion(userRegion),
        child: BlocBuilder<RecommendedPlantsCubit, RecommendedPlantsState>(
          builder: (context, state) {
            if (state.userRegion == null) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_off, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Регион не указан в профиле',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Укажите регион в профиле, чтобы получить рекомендации',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            if (state.plants.isEmpty) {
              return Center(
                child: Text(
                  'Нет рекомендаций для региона:\n${state.userRegion}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.plants.length,
              itemBuilder: (context, index) {
                final plant = state.plants[index];
                return Card(
                  //color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plant.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          plant.type.toUpperCase(),
                          style: TextStyle(color: Colors.lightGreen, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(plant.description),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}