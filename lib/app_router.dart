import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'main.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        int tabIndex = 0;
        final location = state.uri.toString();

        if (location.contains('/my_plants')) tabIndex = 0;
        else if (location.contains('/watering')) tabIndex = 1;
        else if (location.contains('/fertilizers')) tabIndex = 2;
        else if (location.contains('/care_tips')) tabIndex = 3;
        else if (location.contains('/plant_status')) tabIndex = 4;

        return GardenScreen(initialTab: tabIndex);
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => Container(),
        ),
        GoRoute(
          path: '/my_plants',
          name: 'my_plants',
          builder: (context, state) => Container(),
        ),
        GoRoute(
          path: '/watering',
          name: 'watering',
          builder: (context, state) => Container(),
        ),
        GoRoute(
          path: '/fertilizers',
          name: 'fertilizers',
          builder: (context, state) => Container(),
        ),
        GoRoute(
          path: '/care_tips',
          name: 'care_tips',
          builder: (context, state) => Container(),
        ),
        GoRoute(
          path: '/plant_status',
          name: 'plant_status',
          builder: (context, state) => Container(),
        ),
      ],
    ),

    GoRoute(
      path: '/plant_detail',
      name: 'plant_detail',
      builder: (context, state) {
        final plantName = state.uri.queryParameters['name'] ?? 'Растение';
        final plantDescription = state.uri.queryParameters['description'] ?? 'Описание';

        return Scaffold(
          appBar: AppBar(
            title: Text('Детали растения'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plantName,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  plantDescription,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: Text('Вернуться назад'),
                ),
              ],
            ),
          ),
        );
      },
    ),
  ],
);

class AppNavigation {
  static void goToMyPlants(BuildContext context) {
    context.go('/my_plants');
  }

  static void goToWatering(BuildContext context) {
    context.go('/watering');
  }

  static void goToFertilizers(BuildContext context) {
    context.go('/fertilizers');
  }

  static void goToCareTips(BuildContext context) {
    context.go('/care_tips');
  }

  static void goToPlantStatus(BuildContext context) {
    context.go('/plant_status');
  }

  static void pushToPlantDetail(BuildContext context, {required String name, required String description}) {
    context.push(
      '/plant_detail?name=${Uri.encodeComponent(name)}&description=${Uri.encodeComponent(description)}',
    );
  }

  static void goBack(BuildContext context) {
    context.pop();
  }
}