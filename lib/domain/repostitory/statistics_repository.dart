import 'package:dartz/dartz.dart';
import 'package:formify/data/network/failure.dart';

abstract class RepositoryAi {
  Future<Either<Failure, String>> getAiResponse(String prompt);}
