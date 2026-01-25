
import 'package:dartz/dartz.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/request.dart';

abstract class RepositorySql {
  Future<Either<Failure, String>> asyncData(GetAsyncModel asyncData);
  Future<Either<Failure, void>>  deleteData();
  Future<Either<Failure, AllUserModel>> getDataSql();
  Future<Either<Failure, GetAsyncModel>>getConference();
}
