import 'package:farmersfriendapp/core/database/database_helper.dart';
import 'package:farmersfriendapp/core/errors/exceptions.dart';
import 'package:farmersfriendapp/core/models/guideline_with_images.dart';
import 'package:farmersfriendapp/core/models/guideline.dart';
import 'package:farmersfriendapp/core/models/guideline_image.dart';

abstract class GuidelineLocalDataSource {
  Future<List<Guideline>> getGuidelinesForCrop(int cropId);
  Future<List<Guideline>> getGuidelinesForuserid(int cropId);
  Future<List<Guideline>> getAllGuidelines();
  Future<List<Guideline>> getGuidelinesForguidanceID(int cropId);
  Future<Guideline> addGuideline(Guideline guideline);
  Future<Guideline> updateGuideline(Guideline guideline);
  Future<void> deleteGuideline(int guidelineId);
  Future<List<GuidelineImage>> getImagesForGuideline(int guidanceId);
  Future<GuidelineImage> addImageToGuideline(GuidelineImage guidelineImage);
  Future<void> deleteGuidelineImage(int imageGuidelineId);
  Future<List<GuidelineWithImages>> getGuidelinesWithImagesByUserId(int userID);
  Future<List<GuidelineWithImages>> getAllGuidelinesWithImages();
}

class GuidelineLocalDataSourceImpl implements GuidelineLocalDataSource {
  final DatabaseHelper dbHelper;

  GuidelineLocalDataSourceImpl({required this.dbHelper});

  @override
  Future<List<Guideline>> getGuidelinesForCrop(int cropId) async {
    try {
      final maps = await dbHelper.query(
        'AgriculturalGuidelines',
        where: 'CropID = ?',
        whereArgs: [cropId],
      );
      return maps.map((map) => Guideline.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get guidelines: $e');
    }
  }

  @override
  Future<List<Guideline>> getGuidelinesForuserid(int userId) async {
    try {
      final maps = await dbHelper.query(
        'AgriculturalGuidelines',
        where: 'UserID=?',
        whereArgs: [userId],
      );
      return maps.map((map) => Guideline.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get guidelines: $e');
    }
  }

  @override
  Future<List<Guideline>> getGuidelinesForguidanceID(int guidelineID) async {
    try {
      final maps = await dbHelper.query(
        'AgriculturalGuidelines',
        where: 'GuidanceID = ?',
        whereArgs: [guidelineID],
      );
      return maps.map((map) => Guideline.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get guidelines: $e');
    }
  }

  @override
  Future<Guideline> addGuideline(Guideline guideline) async {
    try {
      final guidanceId =
          await dbHelper.insert('AgriculturalGuidelines', guideline.toMap());
      return guideline.copyWith(guidanceId: guidanceId);
    } catch (e) {
      throw DatabaseException('Failed to add guideline: $e');
    }
  }

  @override
  Future<Guideline> updateGuideline(Guideline guideline) async {
    try {
      await dbHelper.update(
        'AgriculturalGuidelines',
        guideline.toMap(),
        where: 'GuidanceID = ?',
        whereArgs: [guideline.guidanceId],
      );
      return guideline;
    } catch (e) {
      throw DatabaseException('Failed to update guideline: $e');
    }
  }

  @override
  Future<void> deleteGuideline(int guidelineId) async {
    try {
      await dbHelper.delete(
        'AgriculturalGuidelines',
        where: 'GuidanceID = ?',
        whereArgs: [guidelineId],
      );
    } catch (e) {
      throw DatabaseException('Failed to delete guideline: $e');
    }
  }

  @override
  Future<List<GuidelineImage>> getImagesForGuideline(int guidanceId) async {
    try {
      final maps = await dbHelper.query('GuidelineImages',
          where: 'GuidanceID = ?', whereArgs: [guidanceId]);
      return maps.map((e) => GuidelineImage.fromMap(e)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get images for guideline: $e');
    }
  }

  @override
  Future<GuidelineImage> addImageToGuideline(
      GuidelineImage guidelineImage) async {
    try {
      final imageGuidelineId =
          await dbHelper.insert('GuidelineImages', guidelineImage.toMap());
      return guidelineImage.copyWith(imageGuidelineId: imageGuidelineId);
    } catch (e) {
      throw DatabaseException('Failed to add image to guideline: $e');
    }
  }

  @override
  Future<void> deleteGuidelineImage(int imageGuidelineId) async {
    try {
      await dbHelper.delete(
        'GuidelineImages',
        where: 'ImageGuidelineID = ?',
        whereArgs: [imageGuidelineId],
      );
    } catch (e) {
      throw DatabaseException('Failed to delete guideline image: $e');
    }
  }

  @override
  Future<List<Guideline>> getAllGuidelines() async {
    try {
      final maps = await dbHelper.queryAllRows('AgriculturalGuidelines');
      return maps.map((map) => Guideline.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get guidelines: $e');
    }
  }

  @override
  Future<List<GuidelineWithImages>> getGuidelinesWithImagesByUserId(
      int UserID) async {
    final List<GuidelineWithImages> guidelinesWithImages = [];

    final guidelines = await getGuidelinesForuserid(UserID);
    for (final guideline in guidelines) {
      final images = await getImagesForGuideline(guideline.guidanceId!);
      guidelinesWithImages
          .add(GuidelineWithImages(guideline: guideline, images: images));
    }

    return guidelinesWithImages;
  }

  @override
  Future<List<GuidelineWithImages>> getAllGuidelinesWithImages() async {
    final List<GuidelineWithImages> guidelinesWithImages = [];
    final guidelines = await getAllGuidelines();
    for (final guideline in guidelines) {
      final images = await getImagesForGuideline(guideline.guidanceId!);
      guidelinesWithImages.add(
        GuidelineWithImages(guideline: guideline, images: images),
      );
    }
    return guidelinesWithImages;
  }
}
