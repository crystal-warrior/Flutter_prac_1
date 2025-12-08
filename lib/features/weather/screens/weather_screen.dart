import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/weather_cubit.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _compareCityController = TextEditingController();
  final TextEditingController _multipleCitiesController = TextEditingController();

  @override
  void dispose() {
    _cityController.dispose();
    _compareCityController.dispose();
    _multipleCitiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Погода'),
      ),
      body: BlocProvider(
        create: (context) => WeatherCubit()..loadWeather(),
        child: BlocBuilder<WeatherCubit, WeatherState>(
          builder: (context, state) {
            if (state.isLoading && state.weather == null && state.forecast == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.error != null && state.weather == null && state.forecast == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Ошибка: ${state.error}',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<WeatherCubit>().loadWeather(),
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<WeatherCubit>().loadWeather(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Поиск по городу
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Поиск погоды по городу',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _cityController,
                                    decoration: const InputDecoration(
                                      hintText: 'Введите название города',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: state.isLoading
                                      ? null
                                      : () {
                                          if (_cityController.text.trim().isNotEmpty) {
                                            context.read<WeatherCubit>().loadWeatherByCity(_cityController.text.trim());
                                          }
                                        },
                                  child: const Text('Найти'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Текущая погода
                    if (state.weather != null) ...[
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text(
                                state.weather!.city,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (state.selectedDate != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  '${state.selectedDate!.day}.${state.selectedDate!.month}.${state.selectedDate!.year}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),
                              Text(
                                state.weather!.temperatureFormatted,
                                style: TextStyle(
                                  fontSize: 64,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                state.weather!.description,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _buildWeatherInfoRow(context,
                                Icons.thermostat,
                                'Ощущается как',
                                state.weather!.feelsLikeFormatted,
                              ),
                              const Divider(),
                              _buildWeatherInfoRow(context,
                                Icons.water_drop,
                                'Влажность',
                                '${state.weather!.humidity}%',
                              ),
                              const Divider(),
                              _buildWeatherInfoRow(context,
                                Icons.air,
                                'Скорость ветра',
                                state.weather!.windSpeedFormatted,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Выбор даты
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Погода на дату',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: state.isLoading
                                  ? null
                                  : () async {
                                      final date = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now().add(const Duration(days: 7)),
                                      );
                                      if (date != null) {
                                        context.read<WeatherCubit>().loadWeatherForDate(date);
                                      }
                                    },
                              icon: const Icon(Icons.calendar_today),
                              label: Text(state.selectedDate != null
                                  ? '${state.selectedDate!.day}.${state.selectedDate!.month}.${state.selectedDate!.year}'
                                  : 'Выбрать дату'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Прогноз на несколько дней
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Прогноз на 7 дней',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: state.isLoading
                                      ? null
                                      : () {
                                          context.read<WeatherCubit>().loadForecast();
                                        },
                                  child: const Text('Загрузить'),
                                ),
                              ],
                            ),
                            if (state.forecast != null && state.forecast!.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              ...state.forecast!.map((weather) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${weather.date.day}.${weather.date.month}.${weather.date.year}',
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                        ),
                                        Text(
                                          weather.temperatureFormatted,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          weather.description,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ] else if (state.forecast != null && state.forecast!.isEmpty) ...[
                              const SizedBox(height: 8),
                              const Text('Прогноз недоступен'),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Сравнение с другим городом
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Сравнение погоды',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Сравнение с одним городом
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _compareCityController,
                                    decoration: const InputDecoration(
                                      hintText: 'Введите город для сравнения',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: state.isLoading
                                      ? null
                                      : () {
                                          if (_compareCityController.text.trim().isNotEmpty) {
                                            context.read<WeatherCubit>().compareWithCity(_compareCityController.text.trim());
                                          }
                                        },
                                  child: const Text('Сравнить'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 8),
                            // Сравнение с несколькими городами (метод 4: getLocationsByCities)
                            const Text(
                              'Сравнение погоды в нескольких регионах',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Полезно для планирования посадок в разных климатических зонах',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _multipleCitiesController,
                              decoration: const InputDecoration(
                                hintText: 'Города через запятую (Москва, Краснодар, Сочи)',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: state.isLoading
                                  ? null
                                  : () {
                                      if (_multipleCitiesController.text.trim().isNotEmpty) {
                                        final cities = _multipleCitiesController.text
                                            .split(',')
                                            .map((e) => e.trim())
                                            .where((e) => e.isNotEmpty)
                                            .toList();
                                        if (cities.isNotEmpty) {
                                          context.read<WeatherCubit>().compareWithMultipleCities(cities);
                                        }
                                      }
                                    },
                              icon: const Icon(Icons.compare_arrows),
                              label: const Text('Сравнить в регионах'),
                            ),
                            if (state.comparison != null && state.comparison!.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              ...state.comparison!.map((weather) => Card(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            weather.city,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                weather.temperatureFormatted,
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context).colorScheme.primary,
                                                ),
                                              ),
                                              Text(
                                                weather.description,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Text('Влажность: ${weather.humidity}%'),
                                              const SizedBox(width: 16),
                                              Text('Ветер: ${weather.windSpeedFormatted}'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () {
                                  context.read<WeatherCubit>().clearComparison();
                                },
                                child: const Text('Очистить сравнение'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    if (state.isLoading && (state.weather != null || state.forecast != null))
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWeatherInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
