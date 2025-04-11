import 'package:farmersfriendapp/core/database/database_helper.dart';
import 'package:farmersfriendapp/core/errors/exceptions.dart';
import 'package:farmersfriendapp/core/models/user.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<User> registerUser(User user);
  Future<User> loginUser(String username, String password);
  Future<User> getUser(int userId);
  Future<User> updateUser(User user);
  Future<int?> getUserId();
  Future<void> clearUserData();
    Future<List<User>> getAllUsers({String? searchTerm});
  Future<void> deleteUser(int userId); // اختياري
  
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final DatabaseHelper dbHelper;

  AuthLocalDataSourceImpl({required this.dbHelper});

  @override
  Future<User> registerUser(User user) async {
    try {
      final userId = await dbHelper.insert('Users', user.toMap());
      // Store the user ID immediately after successful registration.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(AppConstants.prefsUserIdKey, userId);

      return user.copyWith(id: userId);
    } catch (e) {
      throw DatabaseException('Failed to register user: $e');
    }
  }

  @override
  Future<User> loginUser(String username, String password) async {
    try {
      final maps = await dbHelper
          .query('Users', where: 'Username = ?', whereArgs: [username]);

      if (maps.isNotEmpty) {
        final user = User.fromMap(maps.first);
        if (!user.verifyPassword(password)) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt(AppConstants.prefsUserIdKey, user.id!);
          return user;
        } else {
          throw AuthenticationException('Invalid password');
        }
      } else {
        throw AuthenticationException('User not found');
      }
    } catch (e) {
      if (e is AuthenticationException) {
        rethrow;
      }
      throw DatabaseException('Failed to login user: $e');
    }
  }

  @override
  Future<User> getUser(int userId) async {
    try {
      final maps =
          await dbHelper.query('Users', where: 'ID = ?', whereArgs: [userId]);
      if (maps.isNotEmpty) {
        return User.fromMap(maps.first);
      } else {
        throw DatabaseException('User not found');
      }
    } catch (e) {
      throw DatabaseException('Failed to get user: $e');
    }
  }

  @override
  Future<User> updateUser(User user) async {
    try {
      await dbHelper.update(
        'Users',
        user.toMap(),
        where: 'ID = ?',
        whereArgs: [user.id],
      );
      return user;
    } catch (e) {
      throw DatabaseException('Failed to update user: $e');
    }
  }

  @override
  Future<int?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(AppConstants.prefsUserIdKey);
    } catch (e) {
      throw DatabaseException("Failed to get user ID from cache: $e");
    }
  }

  @override
  Future<void> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.prefsUserIdKey);
    } catch (e) {
      throw DatabaseException("Failed to clear user data: $e");
    }
  }
  
 @override
 Future<List<User>> getAllUsers({String? searchTerm}) async {
    try {
      final db = await dbHelper.database;
      String whereClause = '';
      List<dynamic> whereArgs = [];
      if (searchTerm != null && searchTerm.isNotEmpty) {
        whereClause = 'WHERE Name LIKE ? OR Username LIKE ? OR PhoneNumber LIKE ?';
        whereArgs = ['%$searchTerm%', '%$searchTerm%', '%$searchTerm%'];
      }
      final List<Map<String, dynamic>> maps = await db.query(
        'Users',
        where: whereClause.isNotEmpty ? whereClause : null,
        whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
        orderBy: 'Name ASC', // Order by name
      );
      return List.generate(maps.length, (i) => User.fromMap(maps[i]));
    } catch (e) {
      print("Error fetching all users: $e");
      throw DatabaseException('Could not fetch users from database.');
    }
 }

  @override
  Future<void> deleteUser(int userId) async { // اختياري
    try {
      final db = await dbHelper.database;
      final count = await db.delete(
        'Users',
        where: 'ID = ?',
        whereArgs: [userId],
      );
      if (count == 0) {
        throw DatabaseException('User with ID $userId not found for deletion.');
      }
    } catch (e) {
      print("Error deleting user $userId: $e");
      throw DatabaseException('Could not delete user from database.');
    }
  }
}
