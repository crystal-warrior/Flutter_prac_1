import '../../../../core/models/care_tip.dart';
import '../dto/care_tip_dto.dart';

extension CareTipMapper on CareTipDto {
  CareTip toDomain() {
    return CareTip(
      title: title,
      tip: tip,
    );
  }
}

extension CareTipToDto on CareTip {
  CareTipDto toDto() {
    return CareTipDto(
      title: title,
      tip: tip,
    );
  }
}

