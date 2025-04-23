import 'dart:io';
import 'package:farmersfriendapp/core/models/guideline_image.dart';
import 'package:farmersfriendapp/core/models/product_image.dart';
import 'package:farmersfriendapp/core/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
// تأكد من إضافة الاعتمادية cached_network_image إذا لم تكن موجودة
import 'package:cached_network_image/cached_network_image.dart';
// قد تحتاج إلى استيراد نماذج البيانات إذا كنت ستمررها مباشرة
// import 'package:farmersfriendapp/core/models/product_image.dart';
// import 'package:farmersfriendapp/core/models/guideline_image.dart';

class FullScreenImage extends StatefulWidget {
  // تعديل: استخدام List<dynamic> بدلاً من List<String>
  final List<dynamic> images;
  final int initialIndex;

  const FullScreenImage({
    super.key,
    required this.images, // تعديل
    required this.initialIndex,
  });

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  late PageController _pageController;
  late int _currentPage; // تعديل: لا نحتاج لتهيئة هنا، ستأتي من initState

  @override
  void initState() {
    super.initState();
    // تأكد من أن initialIndex ضمن الحدود الصحيحة
    _currentPage = (widget.initialIndex >= 0 && widget.initialIndex < widget.images.length)
        ? widget.initialIndex
        : 0;
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // إضافة: دالة لتحديد مصدر الصورة (مشابهة لتلك الموجودة في ImageGallery)
  ImageProvider _getImageProvider(dynamic imageSource) {
    String imagePath;

    // تحديد مسار الصورة بناءً على النوع
    if (imageSource is String) {
      imagePath = imageSource;
    } else if (imageSource is ProductImage) { // افترضت أنك قد تمرر ProductImage
      imagePath = imageSource.imagePath;
    } else if (imageSource is GuidelineImage) { // افترضت أنك قد تمرر GuidelineImage
       imagePath = imageSource.imagePath;
    } else {
      // نوع غير معروف، استخدم صورة افتراضية أو ارمِ خطأ
      // يمكنك تعديل هذا حسب احتياجك
      print("FullScreenImage: Unknown image source type: ${imageSource.runtimeType}");
      return const AssetImage(AppConstants.defaultguidelineImagePath); // مثال لصورة افتراضية
    }

    // التحقق إذا كان المسار رابط شبكة أو ملف محلي
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return CachedNetworkImageProvider(imagePath);
    } else if (imagePath.isNotEmpty) {
      // تأكد من أن الملف موجود قبل محاولة تحميله لتجنب الأخطاء
      final file = File(imagePath);
      if (file.existsSync()) {
        return FileImage(file);
      } else {
         print("FullScreenImage: File not found at path: $imagePath");
         // يمكنك إرجاع صورة خطأ أو صورة افتراضية هنا
         return const AssetImage(AppConstants.defaultguidelineImagePath); // مثال
      }
    } else {
       print("FullScreenImage: Empty image path provided.");
       return const AssetImage(AppConstants.defaultguidelineImagePath); // مثال
    }
  }

  PhotoViewGalleryPageOptions _buildGalleryItem(BuildContext context, int index) {
    final imageSource = widget.images[index];
    final imageProvider = _getImageProvider(imageSource);
    // استخدام معرف فريد للـ Hero tag، يمكن أن يكون المسار أو الكائن نفسه
    final heroTag = imageSource is String ? imageSource : imageSource.hashCode.toString();

    return PhotoViewGalleryPageOptions(
      
      imageProvider: imageProvider,
      minScale: PhotoViewComputedScale.contained * 0.9,
      maxScale: PhotoViewComputedScale.covered * 2,
      initialScale: PhotoViewComputedScale.contained,
      heroAttributes: PhotoViewHeroAttributes(tag: heroTag), // تعديل: استخدام heroTag
       errorBuilder: (context, error, stackTrace) {
        // يمكنك عرض رسالة خطأ أو أيقونة هنا
        print("Error loading image in FullScreenImage: $error");
        return const Center(child: Icon(Icons.error, color: Colors.red, size: 50));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // تأكد من أن widget.images ليست فارغة
    if (widget.images.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("No Images")),
        body: const Center(child: Text("No images to display.")),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppConstants.backgroundColor.withOpacity(0.9), // نقل لون الخلفية هنا
    appBar: CustomAppBar(title:   "${_currentPage + 1} / ${widget.images.length}",
    ), 
      body: PhotoViewGallery.builder(
        backgroundDecoration: BoxDecoration(color: AppConstants.primaryColor),
        itemCount: widget.images.length,
        builder: _buildGalleryItem, // استخدام الدالة الجديدة
        pageController: _pageController,
        // إزالة backgroundDecoration من هنا لأنها موجودة في Scaffold
        // backgroundDecoration: BoxDecoration(
        //   color: AppConstants.backgroundColor.withOpacity(0.9),
        // ),
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        loadingBuilder: (context, event) => const Center( // إضافة مؤشر تحميل
          child: CircularProgressIndicator(),
        ),
        scrollPhysics: const BouncingScrollPhysics(), // لجعل التمرير أكثر سلاسة
      ),
    );
  }
}