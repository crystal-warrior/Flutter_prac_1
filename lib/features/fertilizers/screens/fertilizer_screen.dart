
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../cubit/fertilizers_cubit.dart';

class FertilizerScreen extends StatelessWidget {
  FertilizerScreen({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String imageUrl = "https://cdn-icons-png.flaticon.com/512/122/122499.png";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Удобрения'),
        backgroundColor: Colors.lightGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
              Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'Добавить удобрение',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: 'Название удобрения',
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.lightGreen, width: 2.0),
                          ),
                          labelStyle: const TextStyle(color: Colors.lightGreen),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          final name = _controller.text;
                          if (name.trim().isNotEmpty) {
                            context.read<FertilizersCubit>().addFertilizer(name);
                            _controller.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Удобрение добавлено!')),
                            );
                          }
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Добавить'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Рекомендуемые удобрения:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.fertilizers.length,
                  itemBuilder: (context, index) {
                    final name = state.fertilizers[index];
                    return GestureDetector(
                      key: ValueKey('fertilizer_${name}_$index'),
                      onTap: () {
                        context.read<FertilizersCubit>().removeFertilizer(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Удобрение удалено!')),
                        );
                      },
                      child: ListTile(
                        leading: const Icon(Icons.agriculture, color: Colors.brown),
                        title: Text(name),
                        trailing: const Icon(Icons.delete_outline, color: Colors.red),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}