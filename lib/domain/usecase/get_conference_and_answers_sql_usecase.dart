import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository_sql.dart';

class GetConferenceAndAnswersSqlUsecase extends Equatable {
  final RepositorySql _repository;
  const GetConferenceAndAnswersSqlUsecase(this._repository);
  Future<Either<Failure, SyncUsersRequest>> execute( int conferenceId) async {
    return await _repository.getConferenceAndAnswers(conferenceId);
  }

  @override
  List<Object?> get props => [_repository];
}
