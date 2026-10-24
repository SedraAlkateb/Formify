import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository_sql.dart';

class InsertDoctorSqlUsecase extends Equatable {
  final RepositorySql _repository;
  const InsertDoctorSqlUsecase(this._repository);
  Future<Either<Failure, void>> execute(UserModel doctor, {bool markAttended = false}) async {
    return await _repository.insertDoctor(doctor, markAttended: markAttended);
  }

  @override
  List<Object?> get props => [_repository];
}
