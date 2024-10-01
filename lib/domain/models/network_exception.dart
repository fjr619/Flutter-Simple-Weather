class NetworkException implements Exception{
  final String message;

  NetworkException(this.message): super();

  @override
  String toString() {
    return message;
  }
}