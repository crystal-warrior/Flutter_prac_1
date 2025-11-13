class CareTip {
  final String title;
  final String tip;

  const CareTip({required this.title, required this.tip});

  Map<String, String> toJson() => {'title': title, 'tip': tip};

  factory CareTip.fromJson(Map<String, String> json) =>
      CareTip(title: json['title']!, tip: json['tip']!);
}