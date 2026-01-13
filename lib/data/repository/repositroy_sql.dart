import 'package:formify/data/network/app_sql_api.dart';
import 'package:formify/domain/repostitory/repository_sql.dart';

class RepositroySqlImp extends RepositorySql {
  final AppSqlApi _databaseHelper;

  RepositroySqlImp(this._databaseHelper);
}
