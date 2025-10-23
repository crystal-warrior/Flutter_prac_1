import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/care_tips/screens/care_tips_screen.dart';
import 'features/fertilizers/screens/fertilizer_screen.dart';
import 'features/my_plants/screens/my_plants_screen.dart';
import 'features/plant/state/plants_container.dart';
import 'features/watering/screens/watering_screen.dart';
import 'main.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'garden',
      builder: (context, state) => GardenScreen(),
      routes: [
        GoRoute(
          path: 'my_plants',
          name: 'my_plants',
          builder: (context, state) => Scaffold(
            appBar: AppBar(
              title: Text('Мои растения'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            body: PlantsContainer(),
          ),
        ),

        GoRoute(
          path: 'watering',
          name: 'watering',
          builder: (context, state) => Scaffold(
            appBar: AppBar(
              title: Text('Полив'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            body: WateringScreen(),
          ),
        ),

        GoRoute(
          path: 'care_tips',
          name: 'care_tips',
          builder: (context, state) => Scaffold(
            appBar: AppBar(
              title: Text('Советы по уходу'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            body: CareTipsScreen(),
          ),
        ),

        GoRoute(
          path: 'fertilizers',
          name: 'fertilizers',
          builder: (context, state) => Scaffold(
            appBar: AppBar(
              title: Text('Удобрения'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            body: FertilizerScreen(),
          ),
        ),

        GoRoute(
          path: 'plant_status',
          name: 'plant_status',
          builder: (context, state) => Scaffold(
            appBar: AppBar(
              title: Text('Состояние растений'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            body: MyPlantsScreen(),
          ),
        ),
      ],
    ),
  ],
);