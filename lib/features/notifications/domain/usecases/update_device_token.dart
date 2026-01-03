import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/notification_repository.dart';

class UpdateDeviceToken {
  final NotificationRepository repository;

  UpdateDeviceToken(this.repository);

  Future<Either<Failure, void>> call(String userId) async {
    final tokenEither = await repository.getDeviceToken();
    return tokenEither.fold((failure) => Left(failure), (token) async {
      if (token != null) {
        return await repository.updateDeviceToken(userId, token);
      }
      return const Right(null);
    });
  }
}
