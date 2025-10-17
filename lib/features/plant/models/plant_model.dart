class PlantModel {
  final String id; // уникальный идент. растения
  final String name; // имя растения
  final String type; // тип растения: куст, дерево и так далее
  final int careComplexity; // сложность ухода за растением от 1 до 10

  const PlantModel({
    required this.id,
    required this.name,
    required this.type,
    required this.careComplexity,
  });

  PlantModel copyWith({
    String? id,
    String? name,
    String? type,
    int? careComplexity,
  }) {
    return PlantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      careComplexity: careComplexity ?? this.careComplexity,
    );
  }
}