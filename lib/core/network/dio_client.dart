import 'package:dio/dio.dart';
import 'network_exceptions.dart';
import 'logging_interceptor.dart';
import 'error_interceptor.dart';

class DioClient {
  late final Dio _dio;


  Dio get dio => _dio;

  DioClient({
    required String baseUrl,
    String? apiKey,
    Duration? connectTimeout,
    Duration? receiveTimeout,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout ?? const Duration(seconds: 30),
        receiveTimeout: receiveTimeout ?? const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );


    _dio.interceptors.add(LoggingInterceptor());
    _dio.interceptors.add(ErrorInterceptor());
    

    if (apiKey != null) {
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            print('Интерсептор: baseUrl = ${options.baseUrl}');
            print('Интерсептор: queryParameters до = ${options.queryParameters}');
            
            // Для Яндекс.Погоды ключ передается через заголовок
            if (options.baseUrl.contains('weather.yandex.ru')) {
              options.headers['X-Yandex-Weather-Key'] = apiKey;
              print('🔑 Добавлен API ключ для Weather в заголовок');
            }
            // Для Geocoding API ключ передается через query параметр
            else if (options.baseUrl.contains('geocode-maps.yandex.ru')) {
              // Объединяем существующие query параметры с API ключом
              options.queryParameters['apikey'] = apiKey;
              print('🔑 Добавлен API ключ для Geocoding: ${apiKey.substring(0, 8)}...');
              print('🔍 Интерсептор: queryParameters после = ${options.queryParameters}');
            }
            // Для OpenWeatherMap API ключ передается через query параметр appid
            else if (options.baseUrl.contains('openweathermap.org')) {
              options.queryParameters['appid'] = apiKey;
              print('🔑 Добавлен API ключ для OpenWeatherMap: ${apiKey.substring(0, 8)}...');
            }
            // Для бесплатных API без ключей ничего не добавляем
            else if (options.baseUrl.contains('ip-api.com')) {
              print('🌐 Используется бесплатный публичный API без ключа: ${options.baseUrl}');
            } else {
              print('⚠️ Неизвестный baseUrl: ${options.baseUrl}');
            }
            handler.next(options);
          },
        ),
      );
    }
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Превышено время ожидания запроса');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 400) {
          return BadRequestException('Некорректный запрос');
        } else if (statusCode == 401) {
          return UnauthorizedException('Требуется авторизация');
        } else if (statusCode == 404) {
          return NotFoundException('Ресурс не найден');
        } else if (statusCode != null && statusCode >= 500) {
          return ServerException('Ошибка сервера');
        }
        return NetworkException('Ошибка сети: ${error.message}');
      case DioExceptionType.cancel:
        return NetworkException('Запрос отменен');
      case DioExceptionType.unknown:
      default:
        return NetworkException('Неизвестная ошибка: ${error.message}');
    }
  }
}

