class PlantingEventDto {
  final int? id;
  final String userLogin;
  final String date;
  final String note;

  PlantingEventDto({
    this.id,
    required this.userLogin,
    required this.date,
    required this.note,
  });


  factory PlantingEventDto.fromMap(Map<String, dynamic> map) {
    return PlantingEventDto(
      id: map['id'] as int?,
      userLogin: map['user_login'] as String,
      date: map['date'] as String,
      note: map['note'] as String,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_login': userLogin,
      'date': date,
      'note': note,
    };
  }


  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_login': userLogin,
      'date': date,
      'note': note,
    };
  }

  // Создание из JSON
  factory PlantingEventDto.fromJson(Map<String, dynamic> json) {
    return PlantingEventDto(
      id: json['id'] as int?,
      userLogin: json['user_login'] as String,
      date: json['date'] as String,
      note: json['note'] as String,
    );
  }
}






