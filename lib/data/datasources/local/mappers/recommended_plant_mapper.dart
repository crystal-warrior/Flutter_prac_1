import '../../../../core/models/recommended_plant.dart';
import '../dto/recommended_plant_dto.dart';

extension RecommendedPlantMapper on RecommendedPlantDto {
  RecommendedPlant toDomain() {
    return RecommendedPlant(
      name: name,
      type: type,
      description: description,
      region: region,
    );
  }
}

