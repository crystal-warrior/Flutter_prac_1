import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jhvostov_prac_1/features/care_tips/screens/care_tips_screen.dart';
import 'package:jhvostov_prac_1/features/fertilizers/screens/fertilizer_screen.dart';
import 'package:jhvostov_prac_1/features/my_plants/screens/my_plants_screen.dart';
import 'package:jhvostov_prac_1/features/plant/state/plants_container.dart';
import 'package:jhvostov_prac_1/features/watering/screens/watering_screen.dart';
import 'package:jhvostov_prac_1/shared/app_theme.dart';

void main() {
  runApp(PlantApp());
}

class PlantApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Мой Сад',
      theme: AppTheme.lightTheme,
      home: GardenScreen(),
    );
  }
}

class GardenScreen extends StatefulWidget {
  @override
  _GardenScreenState createState() => _GardenScreenState();
}

class _GardenScreenState extends State<GardenScreen> with SingleTickerProviderStateMixin {
  final String _imageUrl = "https://ir.ozone.ru/s3/multimedia-b/6606452423.jpg";
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateWithPop(Widget screen, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text(title),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: screen,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мой Сад'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Мои растения'),
            Tab(text: 'Уход за растениями'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: CachedNetworkImage(
                    imageUrl: _imageUrl,
                    progressIndicatorBuilder: (context, url, progress) =>
                    const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 50,
                      ),
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Text(
                  'Добро пожаловать в Сад!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),

              Container(
                width: 250,
                child: ElevatedButton.icon(
                  onPressed: () => _navigateWithPop(PlantsContainer(), 'Мои растения'),
                  icon: Icon(Icons.favorite),
                  label: Text('Все растения'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 250,
                child: ElevatedButton.icon(
                  onPressed: () => _navigateWithPop(MyPlantsScreen(), 'Состояние растений'),
                  icon: Icon(Icons.local_florist_rounded),
                  label: Text('Состояние растений'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ],
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: CachedNetworkImage(
                    imageUrl: _imageUrl,
                    progressIndicatorBuilder: (context, url, progress) =>
                    const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 50,
                      ),
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Приветствие
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Text(
                  'Уход за растениями',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),

              Container( // вертикальная навигация
                child: ElevatedButton.icon(
                  onPressed: () => _navigateWithPop(WateringScreen(), 'Полив'),
                  icon: Icon(Icons.water_drop),
                  label: Text('Полив растений'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 250,
                child: ElevatedButton.icon(
                  onPressed: () => _navigateWithPop(FertilizerScreen(), 'Удобрения'),
                  icon: Icon(Icons.agriculture),
                  label: Text('Удобрения'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 250,
                child: ElevatedButton.icon(
                  onPressed: () => _navigateWithPop(CareTipsScreen(), 'Советы по уходу'),
                  icon: Icon(Icons.lightbulb),
                  label: Text('Советы по уходу'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}