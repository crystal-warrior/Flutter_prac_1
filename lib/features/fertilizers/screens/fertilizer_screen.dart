import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jhvostov_prac_1/features/fertilizers/screens/add_fertilizer_dialog.dart';
import '../cubit/fertilizers_cubit.dart';

class FertilizerScreen extends StatefulWidget {
  const FertilizerScreen({super.key});

  @override
  State<FertilizerScreen> createState() => _FertilizerScreenState();
}

class _FertilizerScreenState extends State<FertilizerScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String imageUrl = "https://cdn-icons-png.flaticon.com/512/122/122499.png";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Удобрения'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<FertilizersCubit, FertilizersState>(
        builder: (context, state) {
          // Фильтрация удобрений по поисковому запросу
          final filteredFertilizers = _searchQuery.isEmpty
              ? state.fertilizers
              : state.fertilizers.where((fertilizer) {
                  final nameMatch = fertilizer.name.toLowerCase().contains(_searchQuery.toLowerCase());
                  final compositionMatch = fertilizer.composition?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false;
                  return nameMatch || compositionMatch;
                }).toList();

          return Column(
            children: [
              Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final imageSize = constraints.maxWidth * 0.5;
                    return SizedBox(
                      width: imageSize,
                      height: imageSize,
                      child: CachedNetworkImage(
                    imageUrl: imageUrl.trim(),
                    progressIndicatorBuilder: (context, url, progress) =>
                    const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 50,
                    ),
                    fit: BoxFit.contain,
                      ),
                    );
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Сохраняйте информацию об используемых удобрениях для каждого растения',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              // Поле поиска
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Поиск по названию или составу...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                  ),
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Список удобрений',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: filteredFertilizers.isEmpty
                    ? Center(
                        child: Text(
                          _searchQuery.isEmpty
                              ? 'Удобрений пока нет.\nНажмите +, чтобы добавить первое!'
                              : 'Ничего не найдено по запросу "$_searchQuery"',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredFertilizers.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final fertilizer = filteredFertilizers[index];
                          final originalIndex = state.fertilizers.indexOf(fertilizer);
                          return Dismissible(
                            key: ValueKey('fertilizer_${fertilizer.name}_$originalIndex'),
                            direction: DismissDirection.startToEnd,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 20),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (direction) {
                              context.read<FertilizersCubit>().removeFertilizer(originalIndex);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Удобрение удалено!')),
                              );
                            },
                            child: Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  dividerColor: Colors.transparent,
                                ),
                                child: ExpansionTile(
                                  tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  childrenPadding: EdgeInsets.zero,
                                  leading: const Icon(Icons.agriculture, color: Colors.brown),
                                  title: Text(
                                    fertilizer.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                children: [
                                  if (fertilizer.description != null)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.info_outline, size: 20, color: Colors.blue),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              fertilizer.description!,
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (fertilizer.application != null)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.schedule, size: 20, color: Colors.green),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'Применение: ${fertilizer.application!}',
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (fertilizer.composition != null)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.science, size: 20, color: Colors.orange),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'Состав: ${fertilizer.composition!}',
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      // Кнопка добавления в правом нижнем углу
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Получаем cubit из текущего контекста и передаём его в диалог
          final cubit = context.read<FertilizersCubit>();
          showDialog(
            context: context,
            builder: (context) => AddFertilizerDialog(cubit: cubit),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}