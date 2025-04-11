// lib/core/errors/exceptions.dart
class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);
  @override
  String toString() => 'DatabaseException: $message';
}

class AuthenticationException implements Exception {
  final String message;
  AuthenticationException(this.message);
  @override
  String toString() => 'AuthenticationException: $message';
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
  @override
  String toString() => 'CacheException: $message';
}

class ProductNotFoundException implements Exception {
  final String message;
  ProductNotFoundException(this.message);
  @override
  String toString() => 'ProductNotFoundException: $message';
}

class CategoryNotFoundException implements Exception {
  final String message;
  CategoryNotFoundException(this.message);
  @override
  String toString() => 'CategoryNotFoundException: $message';
}

class CropNotFoundException implements Exception {
  final String message;
  CropNotFoundException(this.message);
  @override
  String toString() => 'CropNotFoundException: $message';
}

class GuidelineNotFoundException implements Exception {
  final String message;
  GuidelineNotFoundException(this.message);
  @override
  String toString() => 'GuidelineNotFoundException: $message';
}

class ImageUploadException implements Exception {
  final String message;
  ImageUploadException(this.message);
  @override
  String toString() => 'ImageUploadException: $message';
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => 'NetworkException: $message';
}
