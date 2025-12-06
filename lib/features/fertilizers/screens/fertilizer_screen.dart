import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jhvostov_prac_1/features/fertilizers/screens/add_fertilizer_dialog.dart';
import '../cubit/fertilizers_cubit.dart';

class FertilizerScreen extends StatelessWidget {
  const FertilizerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String imageUrl = "https://cdn-icons-png.flaticon.com/512/122/122499.png";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Удобрения'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.lightGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<FertilizersCubit, FertilizersState>(
        builder: (context, state) {
          return Column(
            children: [
              Center(
                child: SizedBox(
                  width: 210,
                  height: 210,
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
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Список удобрений',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: state.fertilizers.isEmpty
                    ? const Center(
                  child: Text(
                    'Удобрений пока нет.\nНажмите +, чтобы добавить первое!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                )
                    : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.fertilizers.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final name = state.fertilizers[index];
                    return Dismissible(
                      key: ValueKey('fertilizer_${name}_$index'),
                      direction: DismissDirection.startToEnd,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        context.read<FertilizersCubit>().removeFertilizer(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Удобрение удалено!')),
                        );
                      },
                      child: Card(
                       // color: Colors.white,
                        child: ListTile(
                          leading: const Icon(Icons.agriculture, color: Colors.brown),
                          title: Text(name),
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
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.white,
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