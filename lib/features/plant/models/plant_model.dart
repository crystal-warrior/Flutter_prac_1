class PlantModel {
  final String id; // уникальный идентификатор
  final String name; // официальное название
  final String? description; // краткое описание
  final String type; // цветок, дерево, куст, принадлежность к семейству
  final int careComplexity; // сложность ухода от 1 до 10

  PlantModel({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    required this.careComplexity,
  });

  PlantModel copyWith({
    String? id,
    String? name,
    String? description,
    String? type,
    int? careComplexity,
  }) {
    return PlantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      careComplexity: careComplexity ?? this.careComplexity,
    );
  }
}