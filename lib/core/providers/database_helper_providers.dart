import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishi_social/core/database/database_helper.dart';

final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper.instance;
});
