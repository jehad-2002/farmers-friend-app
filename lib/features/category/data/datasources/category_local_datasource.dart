import 'package:farmersfriendapp/core/database/database_helper.dart';
import 'package:farmersfriendapp/core/errors/exceptions.dart';
import 'package:farmersfriendapp/core/models/category.dart';

abstract class CategoryLocalDataSource {
  Future<List<Category>> getAllCategories();
  Future<Category> addCategory(Category category);
  Future<Category> updateCategory(Category category);
  Future<void> deleteCategory(int categoryId);
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final DatabaseHelper dbHelper;

  CategoryLocalDataSourceImpl({required this.dbHelper});

  @override
  Future<List<Category>> getAllCategories() async {
    try {
      final maps = await dbHelper.queryAllRows('Categories');
      return maps.map((map) => Category.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get categories: $e');
    }
  }

  @override
  Future<Category> addCategory(Category category) async {
    try {
      final categoryId = await dbHelper.insert('Categories', category.toMap());
      return category.copyWith(categoryId: categoryId);
    } catch (e) {
      throw DatabaseException('Failed to add category: $e');
    }
  }

  @override
  Future<Category> updateCategory(Category category) async {
    try {
      await dbHelper.update(
        'Categories',
        category.toMap(),
        where: 'CategoryID = ?',
        whereArgs: [category.categoryId],
      );
      return category;
    } catch (e) {
      throw DatabaseException('Failed to update category: $e');
    }
  }

  @override
  Future<void> deleteCategory(int categoryId) async {
    try {
      await dbHelper.delete(
        'Categories',
        where: 'CategoryID = ?',
        whereArgs: [categoryId],
      );
    } catch (e) {
      throw DatabaseException('Failed to delete category: $e');
    }
  }
}
