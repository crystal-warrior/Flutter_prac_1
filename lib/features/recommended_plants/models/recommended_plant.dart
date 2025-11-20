class RecommendedPlant {
  final String name;
  final String type; // растение, дерево, кустарник
  final String description;
  final String region; // регион, для которого подходит

  const RecommendedPlant({
    required this.name,
    required this.type,
    required this.description,
    required this.region,
  });
}