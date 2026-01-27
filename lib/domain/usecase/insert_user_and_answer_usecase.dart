import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository_sql.dart';

class InsertUserAndAnswerUsecase extends Equatable {
  final RepositorySql _repository;
  const InsertUserAndAnswerUsecase(this._repository);
  Future<Either<Failure, String>> execute(GetAsyncModel asyncData) async {
    return await _repository.asyncData(asyncData);
  }

  @override
  List<Object?> get props => [_repository];
}
