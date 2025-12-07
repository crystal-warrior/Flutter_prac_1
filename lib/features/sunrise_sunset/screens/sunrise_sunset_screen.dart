import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/sunrise_sunset_cubit.dart';

class SunriseSunsetScreen extends StatelessWidget {
  const SunriseSunsetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SunriseSunsetCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Восход и закат'),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocBuilder<SunriseSunsetCubit, SunriseSunsetState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.error != null) {
              final isCorsError = state.error!.contains('CORS') || state.error!.contains('XMLHttpRequest');
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isCorsError ? Icons.info_outline : Icons.error_outline,
                        color: isCorsError ? Colors.orange : Colors.red,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.error!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isCorsError ? Colors.orange.shade700 : Colors.red,
                          fontSize: 16,
                        ),
                      ),
                      if (!isCorsError) ...[
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<SunriseSunsetCubit>().loadSunriseSunset();
                          },
                          style: ElevatedButton.styleFrom(),
                          child: const Text('Повторить'),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }

            if (state.data == null) {
              return const Center(
                child: Text('Нет данных'),
              );
            }

            final data = state.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Главная карточка с восходом и закатом
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.orange.shade200,
                            Colors.pink.shade200,
                            Colors.purple.shade200,
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.wb_twilight,
                            size: 64,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildTimeCard(
                                icon: Icons.wb_sunny,
                                label: 'Восход',
                                time: data.formatTime(data.sunrise),
                                color: Colors.orange,
                              ),
                              _buildTimeCard(
                                icon: Icons.nightlight_round,
                                label: 'Закат',
                                time: data.formatTime(data.sunset),
                                color: Colors.deepPurple,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.access_time, color: Colors.white),
                                const SizedBox(width: 8),
                                Text(
                                  'Продолжительность дня: ${data.dayLengthFormatted}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Карточка с сумерками
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Сумерки',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildTwilightRow(
                            'Гражданские',
                            data.formatTime(data.civilTwilightBegin),
                            data.formatTime(data.civilTwilightEnd),
                            Colors.blue,
                          ),
                          const SizedBox(height: 8),
                          _buildTwilightRow(
                            'Навигационные',
                            data.formatTime(data.nauticalTwilightBegin),
                            data.formatTime(data.nauticalTwilightEnd),
                            Colors.indigo,
                          ),
                          const SizedBox(height: 8),
                          _buildTwilightRow(
                            'Астрономические',
                            data.formatTime(data.astronomicalTwilightBegin),
                            data.formatTime(data.astronomicalTwilightEnd),
                            Colors.deepPurple,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Карточка с солнечным полднем
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.lens, color: Colors.amber, size: 32),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Солнечный полдень',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  data.formatTime(data.solarNoon),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTimeCard({
    required IconData icon,
    required String label,
    required String time,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTwilightRow(String label, String begin, String end, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    'Начало: $begin',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Конец: $end',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

