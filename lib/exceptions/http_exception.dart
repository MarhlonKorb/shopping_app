/// Classe que trata os erros gerados no sistema
class HttpException implements Exception {
  final String message;
  final int statusCode;

  HttpException({
    required this.message,
    required this.statusCode,
});

@override
  String toString() {
    return message;
  }
}
