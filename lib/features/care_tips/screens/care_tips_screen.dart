
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../cubit/care_tips_cubit.dart';


class CareTipsScreen extends StatelessWidget {
  const CareTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _titleController = TextEditingController();
    final _tipController = TextEditingController();

    final String imageUrl = "https://static.tildacdn.com/tild6438-6539-4066-a439-663263363239/free-icon-grow-plant.png";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Советы по уходу'),
        backgroundColor: Colors.lightGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<CareTipsCubit, CareTipsState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    width: 210,
                    height: 210,
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
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(15),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Добавить новый совет',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'Название совета',
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.lightGreen, width: 2.0),
                            ),
                            labelStyle: const TextStyle(color: Colors.lightGreen),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _tipController,
                          decoration: InputDecoration(
                            labelText: 'Текст совета',
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.lightGreen, width: 2.0),
                            ),
                            labelStyle: const TextStyle(color: Colors.lightGreen),
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final title = _titleController.text;
                              final tip = _tipController.text;
                              if (title.trim().isNotEmpty && tip.trim().isNotEmpty) {
                                context.read<CareTipsCubit>().addTip(title, tip);
                                _titleController.clear();
                                _tipController.clear();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Совет добавлен!')),
                                );
                              }
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Добавить совет'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightGreen,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Советы по уходу:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                for (int i = 0; i < state.tips.length; i++)
                  GestureDetector(
                    key: ValueKey('tip_${state.tips[i].title}_$i'),
                    onTap: () {
                      context.read<CareTipsCubit>().removeTip(i);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Совет удален!')),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    state.tips[i].title,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(state.tips[i].tip),
                            const SizedBox(height: 5),
                            const Text(
                              'Нажмите для удаления',
                              style: TextStyle(fontSize: 10, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}