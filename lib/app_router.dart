import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'autorization.dart';
import 'garden_screen.dart';
import 'features/care_tips/screens/care_tips_screen.dart';
import 'features/fertilizers/screens/fertilizer_screen.dart';
import 'features/my_plants/screens/my_plants_screen.dart';
import 'features/plant/state/plants_container.dart';
import 'features/watering/screens/watering_screen.dart';

late GoRouter appRouter;

void initRouter() {
  appRouter = GoRouter(
    initialLocation: '/auth',
    routes: [
      GoRoute(
        path: '/auth',
        name: 'auth',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const AuthorizationScreen(),
        ),
      ),
      GoRoute(
        path: '/garden',
        name: 'garden',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: GardenScreen(),
        ),
        routes: [
          GoRoute(
            path: 'my_plants',
            name: 'my_plants',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Мои растения'),
                  backgroundColor: Colors.lightGreen,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  ),
                ),
                body: const PlantsContainer(),
              ),
            ),
          ),
          GoRoute(
            path: 'watering',
            name: 'watering',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Полив'),
                  backgroundColor: Colors.lightGreen,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  ),
                ),
                body: WateringScreen(),
              ),
            ),
          ),
          GoRoute(
            path: 'fertilizers',
            name: 'fertilizers',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Удобрения'),
                  backgroundColor: Colors.lightGreen,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  ),
                ),
                body: FertilizerScreen(),
              ),
            ),
          ),
          GoRoute(
            path: 'care_tips',
            name: 'care_tips',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Советы по уходу'),
                  backgroundColor: Colors.lightGreen,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  ),
                ),
                body: CareTipsScreen(),
              ),
            ),
          ),
          GoRoute(
            path: 'plant_status',
            name: 'plant_status',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Состояние растений'),
                  backgroundColor: Colors.lightGreen,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  ),
                ),
                body: MyPlantsScreen(),
              ),
            ),
          ),
        ],
      ),
      GoRoute(path: '/', redirect: (context, state) => '/auth'),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        appBar: AppBar(title: const Text('Ошибка'), backgroundColor: Colors.lightGreen),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 20),
              const Text('Страница не найдена', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => appRouter.go('/garden'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
                child: const Text('Вернуться в сад'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}