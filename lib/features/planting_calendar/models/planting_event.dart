class PlantingEvent
{
  final DateTime date;
  final String note;

  PlantingEvent({required this.date, required this.note});

  // Ключ для хранения в Map: YYYY-MM-DD
  String get dateKey => '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}