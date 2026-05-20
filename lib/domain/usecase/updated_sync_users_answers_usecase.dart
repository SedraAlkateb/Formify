import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository.dart';
class UpdatedSyncUsersAnswersUsecase extends Equatable {
  final Repository _repository;
  const UpdatedSyncUsersAnswersUsecase(this._repository);
  Future<Either<Failure, void>> execute(SyncUsersRequest conference) async {
    return await _repository.updatedSyncUsersAnswers(conference);
  }

  @override
  List<Object?> get props => [_repository];
}
