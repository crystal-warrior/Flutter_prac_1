import 'package:flutter/material.dart';

class ProblemScreen extends StatefulWidget {
  const ProblemScreen({super.key});

  @override
  State<ProblemScreen> createState() => _ProblemScreenState();
}

class _ProblemScreenState extends State<ProblemScreen> {
  final items = List.generate(10, (index) => 'Элемент ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Должно заработать...')),
      body: ListView(
        children: items
            .map((item) => GestureDetector(
          key: ValueKey(item),
          onTap: () => setState(() => items.remove(item)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(item),
          ),
        ))
            .toList(),
      ),
    );
  }
}