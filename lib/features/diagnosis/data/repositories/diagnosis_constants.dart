import 'package:farmersfriendapp/core/utils/app_constants.dart'; // تأكد من صحة هذا المسار
import 'package:flutter/material.dart';

class DiagnosisConstants {
  // مسار ملف نموذج TFLite في مجلد الأصول
  static const String modelPath = AppConstants.bestModelPath; // تأكد من أن هذا المسار صحيح في AppConstants

  // أبعاد الصورة التي يتوقعها النموذج
  static const int imgHeight = 224;
  static const int imgWidth = 224;

  // خريطة لربط فهرس مخرجات النموذج بأسماء الأمراض (باللغتين الإنجليزية والعربية)
  static const Map<int, Map<String, String>> classMapping = {
    0: {'en': 'Apple: Apple scab', 'ar': 'تفاح: جرب التفاح'},
    1: {'en': 'Apple: Black rot', 'ar': 'تفاح: العفن الأسود'},
    2: {'en': 'Apple: Cedar apple rust', 'ar': 'تفاح: صدأ تفاح الأرز'},
    3: {'en': 'Apple: Healthy', 'ar': 'تفاح: صحي'},
    4: {'en': 'Blueberry: Healthy', 'ar': 'توت أزرق: صحي'}, // تم تعديل الترجمة
    5: {'en': 'Cherry (including sour): Powdery mildew', 'ar': 'كرز (بما في ذلك الحامض): البياض الدقيقي'},
    6: {'en': 'Cherry (including sour): Healthy', 'ar': 'كرز (بما في ذلك الحامض): صحي'},
    7: {'en': 'Corn (maize): Cercospora leaf spot Gray leaf spot', 'ar': 'ذرة: بقعة أوراق سيركوسبورا / بقعة الأوراق الرمادية'}, // تم تعديل الترجمة
    8: {'en': 'Corn (maize): Common rust', 'ar': 'ذرة: الصدأ الشائع'},
    9: {'en': 'Corn (maize): Northern Leaf Blight', 'ar': 'ذرة: لفحة الأوراق الشمالية'},
    10: {'en': 'Corn (maize): Healthy', 'ar': 'ذرة: صحي'},
    11: {'en': 'Grape: Black rot', 'ar': 'عنب: العفن الأسود'},
    12: {'en': 'Grape: Esca (Black Measles)', 'ar': 'عنب: إيسكا (الحصبة السوداء)'},
    13: {'en': 'Grape: Leaf blight (Isariopsis Leaf Spot)', 'ar': 'عنب: لفحة الأوراق (بقعة أوراق إيساريوبسيس)'}, // تم تعديل الترجمة
    14: {'en': 'Grape: Healthy', 'ar': 'عنب: صحي'},
    15: {'en': 'Orange: Haunglongbing (Citrus greening)', 'ar': 'برتقال: هوانجلونجبينج (تخضير الحمضيات)'}, // تم تعديل الترجمة
    16: {'en': 'Peach: Bacterial spot', 'ar': 'خوخ: البقعة البكتيرية'}, // تم تعديل الترجمة
    17: {'en': 'Peach: Healthy', 'ar': 'خوخ: صحي'},
    18: {'en': 'Pepper, bell: Bacterial spot', 'ar': 'فلفل رومي: البقعة البكتيرية'}, // تم تعديل الترجمة
    19: {'en': 'Pepper, bell: Healthy', 'ar': 'فلفل رومي: صحي'},
    20: {'en': 'Potato: Early blight', 'ar': 'بطاطس: اللفحة المبكرة'},
    21: {'en': 'Potato: Late blight', 'ar': 'بطاطس: اللفحة المتأخرة'},
    22: {'en': 'Potato: Healthy', 'ar': 'بطاطس: صحي'},
    23: {'en': 'Raspberry: Healthy', 'ar': 'توت العليق: صحي'},
    24: {'en': 'Soybean: Healthy', 'ar': 'فول الصويا: صحي'},
    25: {'en': 'Squash: Powdery mildew', 'ar': 'كوسة: البياض الدقيقي'},
    26: {'en': 'Strawberry: Leaf scorch', 'ar': 'فراولة: احتراق الأوراق'},
    27: {'en': 'Strawberry: Healthy', 'ar': 'فراولة: صحي'},
    28: {'en': 'Tomato: Bacterial spot', 'ar': 'طماطم: البقعة البكتيرية'}, // تم تعديل الترجمة
    29: {'en': 'Tomato: Early blight', 'ar': 'طماطم: اللفحة المبكرة'},
    30: {'en': 'Tomato: Late blight', 'ar': 'طماطم: اللفحة المتأخرة'},
    31: {'en': 'Tomato: Leaf Mold', 'ar': 'طماطم: عفن الأوراق'},
    32: {'en': 'Tomato: Septoria leaf spot', 'ar': 'طماطم: بقعة أوراق سبتوريا'},
    33: {'en': 'Tomato: Spider mites Two-spotted spider mite', 'ar': 'طماطم: العنكبوت الأحمر ذو البقعتين'},
    34: {'en': 'Tomato: Target Spot', 'ar': 'طماطم: بقعة الهدف'},
    35: {'en': 'Tomato: Tomato Yellow Leaf Curl Virus', 'ar': 'طماطم: فيروس تجعد الأوراق الصفراء للطماطم'}, // تم تعديل الترجمة
    36: {'en': 'Tomato: Tomato mosaic virus', 'ar': 'طماطم: فيروس موزاييك الطماطم'},
    37: {'en': 'Tomato: Healthy', 'ar': 'طماطم: صحي'},
  };

  /// دالة مساعدة للحصول على اسم الفئة المترجم بناءً على لغة التطبيق الحالية.
  /// تُستخدم عادة في طبقة الواجهة (UI).
  static String getClassName(BuildContext context, int index) {
    // الحصول على رمز اللغة الحالي من السياق
    final locale = Localizations.localeOf(context).languageCode;
    // محاولة الحصول على الترجمة للغة الحالية، أو الإنجليزية كاحتياط، أو 'Unknown'
    return classMapping[index]?[locale] ?? classMapping[index]?['en'] ?? 'Unknown';
  }
}