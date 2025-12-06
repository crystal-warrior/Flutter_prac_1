import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../cubit/watering_cubit.dart';

class WateringScreen extends StatelessWidget {
  const WateringScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final String imageUrl = "https://cdn-icons-png.flaticon.com/512/4195/4195647.png";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Регуляция полива'),
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
      body: BlocBuilder<WateringCubit, WateringState>(
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
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
                const SizedBox(height: 20),
                Text(
                  'Уровень полива: ${state.waterLevel}%',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                Slider(
                  value: state.waterLevel.toDouble(),
                  min: 0,
                  max: 100,
                  activeColor: Colors.blue,
                  inactiveColor: Colors.blue.withOpacity(0.3),
                  onChanged: (value) {
                    context.read<WateringCubit>().setWaterLevel(value.round());
                  },
                ),
                const SizedBox(height: 20),
                const Text('Регулируйте уровень полива растений удаленно!'),

              ],
            ),
          );
        },
      ),
    );
  }
}