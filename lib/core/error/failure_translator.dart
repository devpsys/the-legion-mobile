import 'package:dio/dio.dart';
import 'package:hive_ce/hive.dart';

import 'dio_exception_mapper.dart';
import 'exceptions.dart';
import 'failures.dart';

/// Runs [action] and guarantees that only a [Failure] escapes.
///
/// Repositories wrap their work in this function so that `DioException`,
/// `HiveError` and any other unexpected object is converted at the
/// data/domain boundary instead of leaking upwards.
Future<T> translateToFailure<T>(Future<T> Function() action) async {
  try {
    return await action();
  } on Failure {
    rethrow;
  } on AppException catch (error) {
    throw error.toFailure();
  } on DioException catch (error) {
    throw DioExceptionMapper.map(error).toFailure();
  } on HiveError catch (error) {
    throw CacheException(
      'Local storage failure: ${error.message}',
      cause: error,
    ).toFailure();
  } catch (error) {
    throw UnexpectedFailure(message: 'Unexpected error: $error', cause: error);
  }
}
