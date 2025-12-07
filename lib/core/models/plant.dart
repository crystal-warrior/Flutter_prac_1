class Plant {
  final String id;
  final String name;
  final String type;
  final int careComplexity;

  const Plant({
    required this.id,
    required this.name,
    required this.type,
    required this.careComplexity,
  });

  Plant copyWith({
    String? id,
    String? name,
    String? type,
    int? careComplexity,
  }) {
    return Plant(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      careComplexity: careComplexity ?? this.careComplexity,
    );
  }
}





