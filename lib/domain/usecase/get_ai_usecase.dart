import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/repostitory/statistics_repository.dart';

class GetAiUsecase extends Equatable {
  final RepositoryAi _repository;
  const GetAiUsecase(this._repository);
  Future<Either<Failure, String>> execute(String des) async {
    return await _repository.getAiResponse(des);
  }

  @override
  List<Object?> get props => [_repository];
}
