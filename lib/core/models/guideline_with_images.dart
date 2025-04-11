import 'package:farmersfriendapp/core/models/guideline.dart';
import 'package:farmersfriendapp/core/models/guideline_image.dart';

class GuidelineWithImages {
  final Guideline guideline;
  final List<GuidelineImage> images;

  GuidelineWithImages({
    required this.guideline,
    required this.images,
  });
}

