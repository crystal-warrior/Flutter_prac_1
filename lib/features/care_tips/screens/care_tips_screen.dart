import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jhvostov_prac_1/features/care_tips/screens/add_tip_dialog.dart';
import '../cubit/care_tips_cubit.dart';

class CareTipsScreen extends StatelessWidget {
  const CareTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String imageUrl = "https://static.tildacdn.com/tild6438-6539-4066-a439-663263363239/free-icon-grow-plant.png";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Советы по уходу'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<CareTipsCubit, CareTipsState>(
        builder: (context, state) {
          return Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final imageSize = constraints.maxWidth * 0.5;
                    return SizedBox(
                      width: imageSize,
                      height: imageSize,
                      child: CachedNetworkImage(
                    imageUrl: imageUrl,
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
                  'Ваши советы по уходу за растениями!',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              // Карточка с локацией
              if (state.isLoadingLocation)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: LinearProgressIndicator(),
                )
              else if (state.location != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 4),
                        child: Text(
                          'Советы выдаются по адресу:',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      Card(
                        color: Theme.of(context).colorScheme.surface,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Ваше местоположение',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      state.location!.fullLocation,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Список советов',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: state.tips.isEmpty
                    ? const Center(
                  child: Text(
                    'Советов пока нет.\nНажмите +, чтобы добавить первый!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                )
                    : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.tips.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final tip = state.tips[index];
                    return Dismissible(
                      key: ValueKey('tip_${tip.title}_$index'),
                      direction: DismissDirection.startToEnd,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        context.read<CareTipsCubit>().removeTip(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Совет удалён')),
                        );
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tip.title,
                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Text(tip.tip),
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

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Получаем cubit из текущего контекста и передаём его в диалог
          final cubit = context.read<CareTipsCubit>();
          showDialog(
            context: context,
            builder: (context) => AddTipDialog(cubit: cubit),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}