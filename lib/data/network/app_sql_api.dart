import 'package:formify/data/network/sqlite_factory.dart';
import 'package:sqflite/sqflite.dart';

abstract class AppSqlApiAbs {
  Future<void> editIsLogin(int repId, int isLogin);
}

class AppSqlApi extends AppSqlApiAbs {
  DatabaseHelper databaseHelper;
  AppSqlApi(this.databaseHelper);
  Future<void> initializeDatabase() async {
    await databaseFactory.debugSetLogLevel(sqfliteLogLevelVerbose);
  }
  Future<void> editIsLogin(int repId, int isLogin) async {
    final mydb = await databaseHelper.database;
    await mydb.update(
      'rep',
      {'isLogin': isLogin},
      where: 'repId = ?',
      whereArgs: [repId],
    );
  }
}
