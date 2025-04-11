import 'dart:io';
import 'dart:typed_data';
import 'package:farmersfriendapp/features/diagnosis/data/repositories/diagnosis_constants.dart'; // تأكد من صحة هذا المسار
import 'package:image/image.dart' as img_lib;
import 'package:tflite_flutter/tflite_flutter.dart';

// واجهة مجردة لمصدر البيانات المحلي للتشخيص
abstract class DiagnosisLocalDataSource {
  /// تحميل نموذج TFLite.
  Future<void> loadModel();

  /// إجراء التشخيص على ملف الصورة المحدد.
  ///
  /// يرجع اسم الفئة المتوقعة (باللغة الإنجليزية) عند النجاح.
  Future<String> runDiagnosis(File imageFile);
}

// التنفيذ الفعلي لمصدر البيانات المحلي
class DiagnosisLocalDataSourceImpl implements DiagnosisLocalDataSource {
  Interpreter? _interpreter; // مفسر TFLite
  bool _isModelLoaded = false; // علم لتتبع حالة تحميل النموذج

  /// التأكد من تحميل النموذج قبل استخدامه.
  Future<void> _ensureModelLoaded() async {
    if (!_isModelLoaded) {
      await loadModel();
    }
    // إذا فشل التحميل لسبب ما
    if (_interpreter == null) {
      throw Exception('فشل تحميل نموذج التشخيص وهو غير متوفر.');
    }
  }

  @override
  Future<void> loadModel() async {
    // لا تقم بإعادة التحميل إذا كان النموذج محملاً بالفعل
    if (_interpreter != null) return;

    try {
      // تحميل النموذج من مجلد الأصول (assets)
      _interpreter = await Interpreter.fromAsset(DiagnosisConstants.modelPath);
      _isModelLoaded = true;
      print("Diagnosis model loaded successfully."); // رسالة تأكيد للتحميل الناجح
    } catch (e) {
      _isModelLoaded = false;
      print("Error loading diagnosis model: $e"); // طباعة الخطأ لتصحيحه
      // رمي استثناء مخصص لتوضيح سبب الفشل
      throw Exception('فشل تحميل النموذج: $e');
    }
  }

  /// معالجة الصورة الأولية لتناسب متطلبات النموذج.
  Float32List _preprocessImage(img_lib.Image image) {
    // تغيير حجم الصورة إلى الأبعاد المطلوبة من قبل النموذج
    final resizedImage = img_lib.copyResize(
      image,
      width: DiagnosisConstants.imgWidth,
      height: DiagnosisConstants.imgHeight,
      interpolation: img_lib.Interpolation.average, // طريقة الاستيفاء عند تغيير الحجم
    );

    // إنشاء قائمة لتخزين بيانات البكسل كأرقام عشرية (float)
    final imageBytes = Float32List(
        DiagnosisConstants.imgHeight * DiagnosisConstants.imgWidth * 3); // H x W x C
    int pixelIndex = 0; // مؤشر لتتبع الموقع في القائمة المسطحة

    // المرور على كل بكسل في الصورة
    for (int y = 0; y < DiagnosisConstants.imgHeight; y++) {
      for (int x = 0; x < DiagnosisConstants.imgWidth; x++) {
        final pixel = resizedImage.getPixel(x, y);
        // تطبيع قيم الألوان (RGB) لتكون بين 0.0 و 1.0
        imageBytes[pixelIndex++] = pixel.r / 255.0; // قناة اللون الأحمر
        imageBytes[pixelIndex++] = pixel.g / 255.0; // قناة اللون الأخضر
        imageBytes[pixelIndex++] = pixel.b / 255.0; // قناة اللون الأزرق
      }
    }
    return imageBytes; // إرجاع القائمة المعالجة
  }

  @override
  Future<String> runDiagnosis(File imageFile) async {
    // تأكد من تحميل النموذج أولاً
    await _ensureModelLoaded();

    try {
      // قراءة بايتات الصورة من الملف
      final imageBytes = await imageFile.readAsBytes();
      // فك ترميز البايتات إلى كائن صورة باستخدام مكتبة image
      final img_lib.Image? decodedImage = img_lib.decodeImage(imageBytes);
      if (decodedImage == null) {
        throw Exception('فشل في فك ترميز ملف الصورة.');
      }

      // معالجة الصورة للحصول على بيانات الإدخال للنموذج
      final inputBytes = _preprocessImage(decodedImage);
      // إعادة تشكيل القائمة المسطحة إلى تنسيق التنسور [1, H, W, C]
      final input = inputBytes.reshape(
          [1, DiagnosisConstants.imgHeight, DiagnosisConstants.imgWidth, 3]);

      // تحديد شكل مصفوفة الإخراج المتوقعة من النموذج [1, عدد_الفئات]
      final outputShape = [1, DiagnosisConstants.classMapping.length];
      // إنشاء قائمة لتلقي مخرجات النموذج (تأكد من تطابق نوع البيانات Float32)
      // يمكن استخدام Float32List مباشرة هنا أيضًا
      final output = List.filled(outputShape[0] * outputShape[1], 0.0)
          .reshape(outputShape);

      // تشغيل النموذج باستخدام المفسر
      _interpreter!.run(input, output);

      // تفسير مخرجات النموذج للحصول على اسم الفئة المتوقعة
      // output[0] يحتوي على قائمة الاحتمالات للفئة
      return _getPredictedClass(output[0] as List<double>);

    } on Exception catch (e) {
      // طباعة الخطأ للمساعدة في التصحيح
      // ignore: avoid_print
      print("حدث خطأ أثناء تشغيل التشخيص: $e");
      // إعادة رمي الاستثناء ليتم التعامل معه في الطبقة الأعلى (Repository)
      rethrow;
    } catch (e) {
      // التعامل مع أي أخطاء غير متوقعة أخرى
      print("حدث خطأ غير متوقع أثناء التشخيص: $e");
      throw Exception('حدث خطأ غير متوقع أثناء التشخيص: $e');
    }
  }

  /// ***-- تم الإصلاح --***
  /// يحدد الفئة ذات الاحتمالية الأعلى من مخرجات النموذج.
  String _getPredictedClass(List<double> predictions) {
    // التحقق من أن قائمة التوقعات ليست فارغة
    if (predictions.isEmpty) {
      throw Exception('تم استلام مصفوفة توقعات فارغة من النموذج.');
    }

    int predictedClassIndex = 0; // فهرس الفئة المتوقعة
    double maxConfidence = -1.0; // أعلى درجة ثقة (يتم تهيئتها بقيمة أقل من الصفر)

    // البحث عن الفهرس ذي القيمة الأعلى (أعلى احتمال)
    predictedClassIndex = predictions.indexWhere((confidence) => confidence == predictions.reduce((a, b) => a > b ? a : b));

    // البحث عن معلومات الفئة باستخدام الفهرس في خريطة الفئات
    final predictedClassInfo =
        DiagnosisConstants.classMapping[predictedClassIndex];

    if (predictedClassInfo == null) {
      throw Exception('Invalid class index $predictedClassIndex in the class mapping.');
    }

    // استخراج الاسم باللغة الإنجليزية كنتيجة أساسية لمصدر البيانات هذا
    final predictedClassNameEn = predictedClassInfo['en'];

    // التحقق من وجود الاسم الإنجليزي
    if (predictedClassNameEn == null || predictedClassNameEn.isEmpty) {
        throw Exception(
              'الاسم الإنجليزي غير موجود لفهرس الفئة المتوقعة $predictedClassIndex في خريطة الفئات.');
    }

    // ***-- السطر المضاف --***
    // إرجاع اسم الفئة المتوقعة (باللغة الإنجليزية في هذه الحالة)
    return predictedClassNameEn;
  }

  // يمكنك إضافة دالة لإغلاق المفسر عند عدم الحاجة إليه
  // void dispose() {
  //   _interpreter?.close();
  //   _interpreter = null;
  //   _isModelLoaded = false;
  // }
}