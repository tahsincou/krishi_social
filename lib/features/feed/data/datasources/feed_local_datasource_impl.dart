import 'package:krishi_social/core/database/database_helper.dart';
import 'package:krishi_social/features/feed/data/datasources/feed_local_datasource.dart';
import 'package:krishi_social/features/feed/data/models/agricultural_post_model.dart';
import 'package:sqflite/sqflite.dart';

class FeedLocalDataSourceImpl implements FeedLocalDataSource {
  const FeedLocalDataSourceImpl(this.databaseHelper);

  final DatabaseHelper databaseHelper;

  @override
  Future<List<AgriculturalPostModel>> getPosts() async {
    final database = await databaseHelper.database;

    final rows = await database.query(
      'agricultural_posts',
      orderBy: 'created_at DESC',
    );

    return rows.map(AgriculturalPostModel.fromDatabase).toList();
  }

  @override
  Future<void> replacePosts(List<AgriculturalPostModel> posts) async {
    final database = await databaseHelper.database;

    await database.transaction((transaction) async {
      await transaction.delete('agricultural_posts');

      final batch = transaction.batch();

      for (final post in posts) {
        batch.insert(
          'agricultural_posts',
          post.toDatabase(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
    });
  }

  @override
  Future<void> savePost(AgriculturalPostModel post) async {
    final database = await databaseHelper.database;

    await database.insert(
      'agricultural_posts',
      post.toDatabase(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deletePost(String postId) async {
    final database = await databaseHelper.database;

    await database.delete(
      'agricultural_posts',
      where: 'id = ?',
      whereArgs: [postId],
    );
  }
}
