import 'package:get_it/get_it.dart';
import '../data/datasources/local/local_auth_data_source.dart';
import '../data/datasources/local/local_care_tips_data_source.dart';
import '../data/datasources/local/local_fertilizers_data_source.dart';
import '../data/datasources/local/local_my_plants_data_source.dart';
import '../data/datasources/local/local_plants_data_source.dart';
import '../data/datasources/local/local_planting_calendar_data_source.dart';
import '../data/datasources/local/local_recommended_plants_data_source.dart';
import '../data/datasources/local/shared_preferences_data_source.dart';
import '../data/datasources/local/secure_storage_data_source.dart';
import '../data/datasources/local/sqlite_planting_calendar_data_source.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/care_tips_repository_impl.dart';
import '../data/repositories/fertilizers_repository_impl.dart';
import '../data/repositories/my_plants_repository_impl.dart';
import '../data/repositories/plants_repository_impl.dart';
import '../data/repositories/planting_calendar_repository_impl.dart';
import '../data/repositories/recommended_plants_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/care_tips_repository.dart';
import '../domain/repositories/fertilizers_repository.dart';
import '../domain/repositories/my_plants_repository.dart';
import '../domain/repositories/plants_repository.dart';
import '../domain/repositories/planting_calendar_repository.dart';
import '../domain/repositories/recommended_plants_repository.dart';
import '../domain/usecases/add_care_tip_usecase.dart';
import '../domain/usecases/add_fertilizer_usecase.dart';
import '../domain/usecases/add_my_plant_usecase.dart';
import '../domain/usecases/add_plant_usecase.dart';
import '../domain/usecases/add_planting_event_usecase.dart';
import '../domain/usecases/authenticate_usecase.dart';
import '../domain/usecases/get_care_tips_usecase.dart';
import '../domain/usecases/get_fertilizers_usecase.dart';
import '../domain/usecases/get_my_plants_usecase.dart';
import '../domain/usecases/get_all_plants_usecase.dart';
import '../domain/usecases/get_planting_events_usecase.dart';
import '../domain/usecases/get_recommended_plants_usecase.dart';
import '../domain/usecases/register_usecase.dart';
import '../core/network/dio_client.dart';
import '../data/datasources/remote/weather_data_source.dart';
import '../data/datasources/remote/location_data_source.dart';
import '../data/datasources/remote/lunar_calendar_data_source.dart';
import '../data/datasources/remote/ip_geolocation_data_source.dart';
import '../data/datasources/remote/openweather_data_source.dart';
import '../data/datasources/remote/sunrise_sunset_data_source.dart';
import '../data/repositories/weather_repository_impl.dart';
import '../data/repositories/location_repository_impl.dart';
import '../data/repositories/lunar_calendar_repository_impl.dart';
import '../data/repositories/ip_geolocation_repository_impl.dart';
import '../data/repositories/openweather_repository_impl.dart';
import '../data/repositories/sunrise_sunset_repository_impl.dart';
import '../domain/repositories/weather_repository.dart';
import '../domain/repositories/location_repository.dart';
import '../domain/repositories/lunar_calendar_repository.dart';
import '../domain/repositories/ip_geolocation_repository.dart';
import '../domain/repositories/openweather_repository.dart';
import '../domain/repositories/sunrise_sunset_repository.dart';
import '../domain/usecases/get_weather_usecase.dart';
import '../domain/usecases/get_location_usecase.dart';
import '../domain/usecases/get_lunar_calendar_usecase.dart';
import '../domain/usecases/get_ip_location_usecase.dart';
import '../domain/usecases/get_openweather_usecase.dart';
import '../domain/usecases/get_sunrise_sunset_usecase.dart';
import '../features/theme/cubit/theme_cubit.dart';

final locator = GetIt.instance;

class UserService {
  String? _login;
  String? get login => _login;
  void setLogin(String login) => _login = login;
  void clearLogin() => _login = null;
}

void setupLocator() {
  // Services
  locator.registerSingleton<UserService>(UserService());

  // Network
  // Яндекс API для погоды
  locator.registerLazySingleton<DioClient>(
    () => DioClient(
      baseUrl: 'https://api.weather.yandex.ru',
      apiKey: '8eba930d-f6cb-4699-95d3-b255235ef0af',
    ),
  );
  
  // Яндекс API для геокодирования (Яндекс.Карты Geocoding API)
  locator.registerLazySingleton<DioClient>(
    instanceName: 'geocode',
    () => DioClient(
      baseUrl: 'https://geocode-maps.yandex.ru',
      apiKey: '93570217-87a3-4b40-a913-552c85a611fa',
    ),
  );

  // IP Geolocation API
  locator.registerLazySingleton<DioClient>(
    instanceName: 'ipgeolocation',
    () => DioClient(
      baseUrl: 'http://ip-api.com',
      apiKey: null, // Не требует ключа
    ),
  );

  // OpenWeatherMap API (бесплатный, требует API ключ)
  // Для получения бесплатного ключа: https://openweathermap.org/api
  // Вставьте ваш API ключ вместо 'YOUR_API_KEY'
  locator.registerLazySingleton<DioClient>(
    instanceName: 'openweather',
    () => DioClient(
      baseUrl: 'https://api.openweathermap.org/data/2.5',
      apiKey: 'YOUR_API_KEY', // Замените на ваш API ключ от OpenWeatherMap
    ),
  );

  // Sunrise-Sunset использует локальные вычисления, не требует DioClient

  // Remote Data Sources
  locator.registerLazySingleton<WeatherDataSource>(
    () => WeatherDataSource(locator<DioClient>()),
  );
  locator.registerLazySingleton<LocationDataSource>(
    () => LocationDataSource(locator<DioClient>(instanceName: 'geocode')),
  );
  locator.registerLazySingleton<LunarCalendarDataSource>(
    () => LunarCalendarDataSource(locator<DioClient>()),
  );
  locator.registerLazySingleton<IpGeolocationDataSource>(
    () => IpGeolocationDataSource(locator<DioClient>(instanceName: 'ipgeolocation')),
  );
  locator.registerLazySingleton<OpenWeatherDataSource>(
    () => OpenWeatherDataSource(locator<DioClient>(instanceName: 'openweather')),
  );
  locator.registerLazySingleton<SunriseSunsetDataSource>(
    () => SunriseSunsetDataSource(), // Теперь использует локальные вычисления, не требует DioClient
  );

  // Data Sources
  locator.registerLazySingleton<LocalAuthDataSource>(
    () => LocalAuthDataSource(
      locator<SharedPreferencesDataSource>(),
      locator<SecureStorageDataSource>(),
    ),
  );
  locator.registerLazySingleton<LocalCareTipsDataSource>(() => LocalCareTipsDataSource());
  locator.registerLazySingleton<LocalFertilizersDataSource>(() => LocalFertilizersDataSource());
  locator.registerLazySingleton<LocalMyPlantsDataSource>(() => LocalMyPlantsDataSource());
  locator.registerLazySingleton<LocalPlantsDataSource>(() => LocalPlantsDataSource());
  locator.registerLazySingleton<LocalPlantingCalendarDataSource>(() => LocalPlantingCalendarDataSource());
  locator.registerLazySingleton<LocalRecommendedPlantsDataSource>(() => LocalRecommendedPlantsDataSource());
  
  // Новые хранилища данных
  locator.registerLazySingleton<SharedPreferencesDataSource>(() => SharedPreferencesDataSource());
  locator.registerLazySingleton<SecureStorageDataSource>(
    () => SecureStorageDataSource(),
  );
  locator.registerLazySingleton<SqlitePlantingCalendarDataSource>(
    () => SqlitePlantingCalendarDataSource(
      sharedPrefs: locator<SharedPreferencesDataSource>(),
    ),
  );

  // Repositories
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      locator<LocalAuthDataSource>(),
      locator<SharedPreferencesDataSource>(),
    ),
  );
  locator.registerLazySingleton<CareTipsRepository>(
    () => CareTipsRepositoryImpl(locator<LocalCareTipsDataSource>()),
  );
  locator.registerLazySingleton<FertilizersRepository>(
    () => FertilizersRepositoryImpl(locator<LocalFertilizersDataSource>()),
  );
  locator.registerLazySingleton<MyPlantsRepository>(
    () => MyPlantsRepositoryImpl(locator<LocalMyPlantsDataSource>()),
  );
  locator.registerLazySingleton<PlantsRepository>(
    () => PlantsRepositoryImpl(
      locator<LocalPlantsDataSource>(),
    ),
  );
  locator.registerLazySingleton<PlantingCalendarRepository>(
    () => PlantingCalendarRepositoryImpl(
      locator<LocalPlantingCalendarDataSource>(),
      locator<SqlitePlantingCalendarDataSource>(),
    ),
  );
  locator.registerLazySingleton<RecommendedPlantsRepository>(
    () => RecommendedPlantsRepositoryImpl(locator<LocalRecommendedPlantsDataSource>()),
  );
  locator.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      locator<WeatherDataSource>(),
      locator<LocationDataSource>(),
    ),
  );
  locator.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(locator<LocationDataSource>()),
  );
  locator.registerLazySingleton<LunarCalendarRepository>(
    () => LunarCalendarRepositoryImpl(locator<LunarCalendarDataSource>()),
  );
  locator.registerLazySingleton<IpGeolocationRepository>(
    () => IpGeolocationRepositoryImpl(locator<IpGeolocationDataSource>()),
  );
  locator.registerLazySingleton<OpenWeatherRepository>(
    () => OpenWeatherRepositoryImpl(locator<OpenWeatherDataSource>()),
  );
  locator.registerLazySingleton<SunriseSunsetRepository>(
    () => SunriseSunsetRepositoryImpl(locator<SunriseSunsetDataSource>()),
  );

  // Use Cases
  locator.registerLazySingleton<GetAllPlantsUseCase>(
    () => GetAllPlantsUseCase(locator<PlantsRepository>()),
  );
  locator.registerLazySingleton<AddPlantUseCase>(
    () => AddPlantUseCase(locator<PlantsRepository>()),
  );
  locator.registerLazySingleton<GetMyPlantsUseCase>(
    () => GetMyPlantsUseCase(locator<MyPlantsRepository>()),
  );
  locator.registerLazySingleton<AddMyPlantUseCase>(
    () => AddMyPlantUseCase(locator<MyPlantsRepository>()),
  );
  locator.registerLazySingleton<GetCareTipsUseCase>(
    () => GetCareTipsUseCase(locator<CareTipsRepository>()),
  );
  locator.registerLazySingleton<AddCareTipUseCase>(
    () => AddCareTipUseCase(locator<CareTipsRepository>()),
  );
  locator.registerLazySingleton<GetRecommendedPlantsUseCase>(
    () => GetRecommendedPlantsUseCase(locator<RecommendedPlantsRepository>()),
  );
  locator.registerLazySingleton<GetFertilizersUseCase>(
    () => GetFertilizersUseCase(locator<FertilizersRepository>()),
  );
  locator.registerLazySingleton<AddFertilizerUseCase>(
    () => AddFertilizerUseCase(locator<FertilizersRepository>()),
  );
  locator.registerLazySingleton<AuthenticateUseCase>(
    () => AuthenticateUseCase(locator<AuthRepository>()),
  );
  locator.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(locator<AuthRepository>()),
  );
  locator.registerLazySingleton<GetPlantingEventsUseCase>(
    () => GetPlantingEventsUseCase(locator<PlantingCalendarRepository>()),
  );
  locator.registerLazySingleton<AddPlantingEventUseCase>(
    () => AddPlantingEventUseCase(locator<PlantingCalendarRepository>()),
  );
  locator.registerLazySingleton<GetWeatherUseCase>(
    () => GetWeatherUseCase(locator<WeatherRepository>()),
  );
  locator.registerLazySingleton<GetLocationUseCase>(
    () => GetLocationUseCase(locator<LocationRepository>()),
  );
  locator.registerLazySingleton<GetLunarCalendarUseCase>(
    () => GetLunarCalendarUseCase(locator<LunarCalendarRepository>()),
  );

  // Cubits
  // ThemeCubit должен быть singleton, чтобы все части приложения использовали один экземпляр
  locator.registerSingleton<ThemeCubit>(
    ThemeCubit(),
  );
  locator.registerLazySingleton<GetIpLocationUseCase>(
    () => GetIpLocationUseCase(locator<IpGeolocationRepository>()),
  );
  locator.registerLazySingleton<GetOpenWeatherUseCase>(
    () => GetOpenWeatherUseCase(locator<OpenWeatherRepository>()),
  );
  locator.registerLazySingleton<GetSunriseSunsetUseCase>(
    () => GetSunriseSunsetUseCase(locator<SunriseSunsetRepository>()),
  );
}
