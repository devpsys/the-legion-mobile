import 'package:dio/dio.dart';

import '../error/dio_exception_mapper.dart';
import '../error/exceptions.dart';

/// Executes a Dio call and converts transport errors into [AppException]s.
///
/// Remote datasources wrap every request with this function, which keeps the
/// `DioException` -> `AppException` mapping in exactly one place.
Future<T> apiCall<T>(Future<T> Function() action) async {
  try {
    return await action();
  } on DioException catch (error) {
    throw DioExceptionMapper.map(error);
  }
}
