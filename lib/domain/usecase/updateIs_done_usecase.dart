import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/repostitory/repository_sql.dart';

class UpdateDoneUsecase extends Equatable {
  final RepositorySql _repository;
  const UpdateDoneUsecase(this._repository);
  Future<Either<Failure, void>> execute(int isDone,int doctorId) async {
    return await _repository.updateIsDone(isDone, doctorId);
  }

  @override
  List<Object?> get props => [_repository];
}
