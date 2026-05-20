import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository_sql.dart';

class GetUsersConferenceUsecase extends Equatable {
  final RepositorySql _repository;
  const GetUsersConferenceUsecase(this._repository);
  Future<Either<Failure, List<UserModel>>> execute(int conferenceId) async {
    return await _repository.getUserConference( conferenceId);
  }

  @override
  List<Object?> get props => [_repository];
}
