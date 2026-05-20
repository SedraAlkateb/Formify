import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository.dart';
class GetAllUsersForSyncUsecase extends Equatable {
  final Repository _repository;
  const GetAllUsersForSyncUsecase(this._repository);
  Future<Either<Failure, SaveDataBaseModel>> execute(int conferenceId) async {
    return await _repository.getAllUsersForSync(conferenceId);
  }

  @override
  List<Object?> get props => [_repository];
}
