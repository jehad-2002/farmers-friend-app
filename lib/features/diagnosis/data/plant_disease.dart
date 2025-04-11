// يمكن استخدام هذا الكلاس إذا كنت تريد تمثيل نتيجة التشخيص ككائن بدلاً من مجرد سلسلة نصية
// حاليًا، الكود يستخدم سلسلة نصية مباشرة، لذا هذا الكلاس غير مستخدم بشكل فعال في التدفق الحالي.
class PlantDisease {
  final String name; // اسم المرض (أو "صحي")
  final int? index; // الفهرس المقابل في النموذج (اختياري)
  final String? description; // وصف إضافي (اختياري)

  PlantDisease({required this.name, this.index, this.description});

  @override
  String toString() {
    return 'PlantDisease{name: $name, index: $index, description: $description}';
  }
}