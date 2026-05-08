import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository_sql.dart';

class GetDoctorsSqlUsecase extends Equatable {
  final RepositorySql _repository;
  const GetDoctorsSqlUsecase(this._repository);
  Future<Either<Failure, List<DoctorsModel>>> execute() async {
    return await _repository.getDoctors();
  }

  @override
  List<Object?> get props => [_repository];
}
