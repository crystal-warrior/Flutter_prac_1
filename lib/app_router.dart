import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jhvostov_prac_1/features/plant/models/plant_model.dart';
import 'main.dart';
import '../features/plant/screens/plant_form_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/my_plants',
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
          redirect: (context, state) => '/my_plants',
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
      path: '/plant_form',
      name: 'plant_form',
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: PlantFormScreen(
            onSave: (String name, String type, int careComplexity) {

              final newPlant = PlantModel(
                id: DateTime.now().microsecondsSinceEpoch.toString(),
                name: name,
                type: type,
                careComplexity: careComplexity,
              );
              context.pop(newPlant);
            },
            onCancel: () {
              context.pop();
            },
          ),
        );
      },
    ),

    GoRoute(
      path: '/plant_detail',
      name: 'plant_detail',
      pageBuilder: (context, state) {
        final plantName = state.uri.queryParameters['name'] ?? 'Растение';
        final plantDescription = state.uri.queryParameters['description'] ?? 'Описание';

        return MaterialPage(
          key: state.pageKey,
          child: Scaffold(
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
          ),
        );
      },
    ),
  ],
);