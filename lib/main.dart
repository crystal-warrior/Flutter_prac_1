import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jhvostov_prac_1/app_router.dart';
import 'package:jhvostov_prac_1/shared/app_theme.dart';
import 'features/care_tips/screens/care_tips_screen.dart';
import 'features/fertilizers/screens/fertilizer_screen.dart';
import 'features/my_plants/screens/my_plants_screen.dart';
import 'features/plant/state/plants_container.dart';
import 'features/watering/screens/watering_screen.dart';

void main() {
  runApp(PlantApp());
}

class PlantApp extends StatelessWidget {
  PlantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Мой Сад',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}

class GardenScreen extends StatefulWidget {
  final int? initialTab;

  const GardenScreen({super.key, this.initialTab});

  @override
  _GardenScreenState createState() => _GardenScreenState();
}

class _GardenScreenState extends State<GardenScreen> with SingleTickerProviderStateMixin {
  final String _imageUrl = "https://ir.ozone.ru/s3/multimedia-b/6606452423.jpg";
  late TabController _tabController;
  int _currentTabIndex = 0;

  final List<Map<String, dynamic>> _tabs = [
    {
      'title': 'Мои растения',
      'icon': Icons.favorite,
      'widget': PlantsContainer(),
      'route': '/my_plants',
    },
    {
      'title': 'Полив',
      'icon': Icons.water_drop,
      'widget': WateringScreen(),
      'route': '/watering',
    },
    {
      'title': 'Удобрения',
      'icon': Icons.agriculture,
      'widget': FertilizerScreen(),
      'route': '/fertilizers',
    },
    {
      'title': 'Советы по уходу',
      'icon': Icons.lightbulb,
      'widget': CareTipsScreen(),
      'route': '/care_tips',
    },
    {
      'title': 'Состояние',
      'icon': Icons.eco,
      'widget': MyPlantsScreen(),
      'route': '/plant_status',
    },
  ];

  @override
  void initState() {
    super.initState();


    final initialIndex = widget.initialTab ?? 0;
    _currentTabIndex = initialIndex;
    _tabController = TabController(length: _tabs.length, vsync: this, initialIndex: initialIndex);

    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });

      final routeName = _tabs[_tabController.index]['route'];
      context.go(routeName);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tabs[_currentTabIndex]['title']),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          onTap: (index) {
            final routeName = _tabs[index]['route'];
            context.go(routeName);
          },
          tabs: _tabs.map((tab) => Tab(
            icon: Icon(tab['icon']),
            text: tab['title'],
          )).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map<Widget>((tab) => tab['widget']).toList(),
      ),
    );
  }
}