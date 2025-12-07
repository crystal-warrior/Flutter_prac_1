class CareTipDto {
  final String title;
  final String tip;

  CareTipDto({
    required this.title,
    required this.tip,
  });

  Map<String, String> toJson() => {
    'title': title,
    'tip': tip,
  };

  factory CareTipDto.fromJson(Map<String, String> json) => CareTipDto(
    title: json['title']!,
    tip: json['tip']!,
  );
}





