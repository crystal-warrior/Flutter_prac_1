import 'package:dio/dio.dart';
import 'network_exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Exception exception;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        exception = TimeoutException('Превышено время ожидания запроса');
        break;
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        if (statusCode == 400) {
          exception = BadRequestException('Некорректный запрос');
        } else if (statusCode == 401) {
          exception = UnauthorizedException('Требуется авторизация');
        } else if (statusCode == 404) {
          exception = NotFoundException('Ресурс не найден');
        } else if (statusCode != null && statusCode >= 500) {
          exception = ServerException('Ошибка сервера');
        } else {
          exception = NetworkException('Ошибка сети: ${err.message}');
        }
        break;
      case DioExceptionType.cancel:
        exception = NetworkException('Запрос отменен');
        break;
      case DioExceptionType.unknown:
      default:
        exception = NetworkException('Неизвестная ошибка: ${err.message}');
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: exception,
        type: err.type,
        response: err.response,
      ),
    );
  }
}












