import 'package:flutter/material.dart';
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
    return MaterialApp(
      title: 'Мой Сад',
      theme: AppTheme.lightTheme,
      home: MainTabScreen(initialTab: 0),
    );
  }
}

class MainTabScreen extends StatefulWidget {
  final int initialTab;

  const MainTabScreen({super.key, required this.initialTab});

  @override
  _MainTabScreenState createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _tabs = [
    {
      'title': 'Мои растения',
      'icon': Icons.favorite,
      'widget': PlantsContainer(),
    },
    {
      'title': 'Полив',
      'icon': Icons.water_drop,
      'widget': WateringScreen(),
    },
    {
      'title': 'Удобрения',
      'icon': Icons.agriculture,
      'widget': FertilizerScreen(),
    },
    {
      'title': 'Советы по уходу',
      'icon': Icons.lightbulb,
      'widget': CareTipsScreen(),
    },
    {
      'title': 'Состояние',
      'icon': Icons.eco,
      'widget': MyPlantsScreen(),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this, initialIndex: widget.initialTab);
  }


  void _navigateToTab(int index) {
    if (index == _tabController.index) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainTabScreen(initialTab: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          onTap: _navigateToTab,
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}