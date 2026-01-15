
import 'package:dartz/dartz.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';

abstract class RepositorySql {
  Future<Either<Failure, String>> asyncData(GetAsyncModel asyncData);
}
