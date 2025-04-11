import 'package:farmersfriendapp/core/database/database_helper.dart';
import 'package:farmersfriendapp/core/errors/exceptions.dart';
import 'package:farmersfriendapp/core/models/crop.dart';

abstract class CropLocalDataSource {
  Future<List<Crop>> getAllCrops();
  Future<Crop> addCrop(Crop crop);
  Future<Crop> updateCrop(Crop crop);
  Future<void> deleteCrop(int cropId);
  Future<Crop?> getCropById(int cropId);
}

class CropLocalDataSourceImpl implements CropLocalDataSource {
  final DatabaseHelper dbHelper;
  CropLocalDataSourceImpl({required this.dbHelper});

  @override
  Future<List<Crop>> getAllCrops() async {
    try {
      final maps = await dbHelper.queryAllRows('Crops');
      return maps.map((map) => Crop.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get crops: $e');
    }
  }

  @override
  Future<Crop> addCrop(Crop crop) async {
    try {
      final cropId = await dbHelper.insert('Crops', crop.toMap());
      return crop.copyWith(cropId: cropId);
    } catch (e) {
      throw DatabaseException('Failed to add crop: $e');
    }
  }

  @override
  Future<Crop> updateCrop(Crop crop) async {
    try {
      await dbHelper.update(
        'Crops',
        crop.toMap(),
        where: 'CropID = ?',
        whereArgs: [crop.cropId],
      );
      return crop;
    } catch (e) {
      throw DatabaseException('Failed to update crop: $e');
    }
  }

  @override
  Future<void> deleteCrop(int cropId) async {
    try {
      await dbHelper.delete(
        'Crops',
        where: 'CropID = ?',
        whereArgs: [cropId],
      );
    } catch (e) {
      throw DatabaseException('Failed to delete crop: $e');
    }
  }

  @override
  Future<Crop?> getCropById(int cropId) async {
    try {
      final maps = await dbHelper.query(
        'Crops',
        where: 'CropID = ?',
        whereArgs: [cropId],
      );
      if (maps.isNotEmpty) {
        return Crop.fromMap(maps.first);
      } else {
        return null;
      }
    } catch (e) {
      throw DatabaseException('Failed to get crop by ID: $e');
    }
  }
}
