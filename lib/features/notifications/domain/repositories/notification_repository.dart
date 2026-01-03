import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class NotificationRepository {
  Future<Either<Failure, String?>> getDeviceToken();
  Future<Either<Failure, void>> updateDeviceToken(String userId, String token);
}
