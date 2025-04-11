import 'dart:io';
import 'package:farmersfriendapp/core/presentation/widgets/app_button.dart'; // تأكد من صحة المسار
import 'package:farmersfriendapp/core/presentation/widgets/loading_indicator.dart'; // تأكد من صحة المسار
import 'package:farmersfriendapp/core/service_locator.dart'; // للحصول على حالة الاستخدام عبر sl (تأكد من إعداده)
import 'package:farmersfriendapp/core/utils/app_constants.dart'; // تأكد من صحة المسار
import 'package:farmersfriendapp/features/diagnosis/domain/usecases/diagnose_image.dart'; // تأكد من صحة المسار
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // للترجمة (تأكد من إعداد الترجمة)

// تعداد لتمثيل الحالات المختلفة لواجهة مستخدم الشاشة
enum DiagnosisScreenStatus {
  initial,        // الحالة الأولية، لا يوجد صورة
  imageSelected,  // تم اختيار صورة، جاهز للتشخيص
  loading,        // جاري التشخيص
  success,        // نجح التشخيص وعرض النتيجة
  error           // حدث خطأ
}

class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({super.key});

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  // --- متغيرات الحالة ---
  File? _imageFile; // لتخزين ملف الصورة المختار
  DiagnosisScreenStatus _status = DiagnosisScreenStatus.initial; // حالة الواجهة الحالية
  String? _diagnosisResult; // لتخزين نتيجة التشخيص الناجحة
  String? _errorMessage; // لتخزين رسالة الخطأ

  // --- الاعتماديات ---
  // الحصول على نسخة من حالة الاستخدام (Use Case) من محدد موقع الخدمة (Service Locator)
  late final DiagnoseImage _diagnoseImageUseCase;

  @override
  void initState() {
    super.initState();
    try {
      _diagnoseImageUseCase = sl.diagnoseImage;
    } catch (e) {
      print("Error initializing DiagnosisScreen: Could not get DiagnoseImage from Service Locator.");
      setState(() {
        _status = DiagnosisScreenStatus.error;
        _errorMessage = "Failed to initialize diagnosis feature.";
      });
    }
  }

  // --- دوال منطق الواجهة ---

  /// اختيار صورة من المصدر المحدد (المعرض أو الكاميرا).
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: source,
        // اختياري: تعديل جودة/حجم الصورة أثناء الالتقاط
        // imageQuality: 80,
        // maxHeight: 1024,
        // maxWidth: 1024,
      );

      if (pickedFile != null && mounted) { // التحقق من mounted مهم قبل setState
        // تحديث الحالة إذا تم اختيار صورة بنجاح
        setState(() {
          _imageFile = File(pickedFile.path);
          _status = DiagnosisScreenStatus.imageSelected; // جاهز للتشخيص
          _diagnosisResult = null; // مسح النتائج السابقة
          _errorMessage = null; // مسح الأخطاء السابقة
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print("خطأ في اختيار الصورة: $e");
      if (mounted) { // التحقق من mounted مهم قبل setState
        // عرض خطأ إذا فشل اختيار الصورة
        final localizations = AppLocalizations.of(context)!;
        setState(() {
          _status = DiagnosisScreenStatus.error;
          // استخدام مفتاح ترجمة محدد لأخطاء اختيار الصورة
          _errorMessage = localizations.errorPickingImage;
        });
      }
    }
  }

  /// عرض قائمة سفلية للاختيار بين الكاميرا والمعرض.
  void _showImageSourceActionSheet() {
    // تأكد من أن السياق لا يزال صالحًا
    if (!mounted) return;
    final localizations = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        // تصميم اختياري
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.borderRadiusMedium)),
      ),
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: Text(localizations.chooseFromGallery),
                  onTap: () {
                    Navigator.of(ctx).pop(); // أغلق القائمة السفلية
                    _pickImage(ImageSource.gallery);
                  }),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: Text(localizations.takePhoto),
                onTap: () {
                  Navigator.of(ctx).pop(); // أغلق القائمة السفلية
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// تشغيل عملية التشخيص باستخدام ملف الصورة المحدد.
  Future<void> _runDiagnosis() async {
    if (_imageFile == null || _status == DiagnosisScreenStatus.loading) return;

    if (_diagnoseImageUseCase == null) {
      if (mounted) {
        final localizations = AppLocalizations.of(context)!;
        setState(() {
          _status = DiagnosisScreenStatus.error;
          _errorMessage = localizations.error; // Needs localization key
        });
      }
      return;
    }

    setState(() {
      _status = DiagnosisScreenStatus.loading;
      _errorMessage = null;
      _diagnosisResult = null;
    });

    final result = await _diagnoseImageUseCase(_imageFile!);

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _status = DiagnosisScreenStatus.error;
          _errorMessage = failure.getLocalizedMessage(context);
        });
      },
      (diagnosisResult) {
        setState(() {
          _status = DiagnosisScreenStatus.success;
          _diagnosisResult = diagnosisResult;
        });
      },
    );
  }

  /// إعادة تعيين الحالة إلى قيمها الأولية.
  void _clearState() {
    if (!mounted) return;
    setState(() {
      _imageFile = null;
      _status = DiagnosisScreenStatus.initial;
      _diagnosisResult = null;
      _errorMessage = null;
    });
  }

  // --- دالة البناء (Build Method) ---

  @override
  Widget build(BuildContext context) {
    // الحصول على نسخة الترجمة لسهولة الوصول إليها في دوال البناء
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      // يمكنك إضافة AppBar هنا إذا أردت
      // appBar: AppBar(
      //   title: Text(localizations.plantDiagnosisTitle), // استخدام عنوان مترجم
      // ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // تمديد العناصر الأفقية
          children: [
            // 1. منطقة عرض/اختيار الصورة
            Expanded(
              flex: 3, // تأخذ مساحة عمودية أكبر
              child: Container(
                alignment: Alignment.center, // توسيط المحتوى
                padding: const EdgeInsets.all(AppConstants.smallPadding),
                decoration: BoxDecoration(
                    color: AppConstants.greenLightColor.withOpacity(0.3),
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadiusMedium),
                    border: Border.all(
                        color: AppConstants.primaryColor.withOpacity(0.5))),
                child:
                    _buildImageArea(localizations), // تفويض لدالة مساعدة
              ),
            ),
            const SizedBox(height: AppConstants.mediumPadding),

            // 2. منطقة عرض النتيجة/التحميل/الخطأ
            Expanded(
                flex: 2, // تأخذ مساحة عمودية أقل من الصورة
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(AppConstants.smallPadding),
                  child: _buildResultArea(localizations), // تفويض لدالة مساعدة
                )),
            const SizedBox(height: AppConstants.mediumPadding),

            // 3. منطقة أزرار الإجراءات
            _buildActionButtons(localizations), // تفويض لدالة مساعدة
          ],
        ),
      ),
    );
  }

  // --- دوال البناء المساعدة ---

  /// بناء الويدجت لمنطقة عرض الصورة بناءً على الحالة الحالية.
  Widget _buildImageArea(AppLocalizations localizations) {
    if (_imageFile != null) {
      // عرض الصورة المختارة
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium -
            AppConstants.smallPadding), // تعديل لنصف قطر الحاوية
        child: Image.file(
          _imageFile!,
          fit: BoxFit.contain, // ملائمة الصورة داخل الحاوية
          errorBuilder: (context, error, stackTrace) {
            // اختياري: معالجة أخطاء تحميل الصورة بشكل خاص
            return Center(child: Text(localizations.errorLoadingImage));
          },
        ),
      );
    } else {
      // عرض عنصر نائب وزر لاختيار صورة
      return SingleChildScrollView( // للسماح بالتمرير إذا تجاوز المحتوى
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_search_outlined,
                size: 70,
                color: AppConstants.primaryColorDark.withOpacity(0.6)),
            const SizedBox(height: AppConstants.defaultPadding),
            Text(
              localizations.selectImageForDiagnosis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    color: AppConstants.textColorSecondary,
                  ),
            ),
            const SizedBox(height: AppConstants.mediumPadding),
            AppButton(
              minWidth: 220,
              text: localizations.chooseImage,
              icon: Icons.add_photo_alternate_outlined,
              onPressed: _showImageSourceActionSheet,
            ),
          ],
        ),
      );
    }
  }

  /// بناء الويدجت لمنطقة عرض النتيجة بناءً على الحالة الحالية.
  Widget _buildResultArea(AppLocalizations localizations) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_status == DiagnosisScreenStatus.success) ...[
            Text(
              localizations.diagnosisResult,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppConstants.primaryColorDark,
                  ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              _diagnosisResult ?? localizations.unknown,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppConstants.brownColor,
                  ),
              textAlign: TextAlign.center,
            ),
          ] else if (_status == DiagnosisScreenStatus.error) ...[
            Icon(
              AppConstants.errorOutlineIcon,
              color: AppConstants.errorColor,
              size: 45,
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              localizations.errorOccurred,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppConstants.errorColor,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: AppConstants.smallPadding / 2),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.smallPadding),
                child: Text(
                  _errorMessage!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppConstants.errorColor.withOpacity(0.9),
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  /// بناء أزرار الإجراءات في الأسفل بناءً على الحالة الحالية.
  Widget _buildActionButtons(AppLocalizations localizations) {
    // تحديد ما إذا كان زر "بدء التشخيص" يجب أن يكون مفعلاً
    bool canDiagnose =
        _imageFile != null && _status != DiagnosisScreenStatus.loading;
    // تحديد ما إذا كان زر "مسح" أو "تشخيص صورة أخرى" يجب عرضه
    bool showClearButton = _imageFile != null ||
        _status == DiagnosisScreenStatus.error ||
        _status == DiagnosisScreenStatus.success;

    return Column(
      mainAxisSize: MainAxisSize.min, // أخذ أقل مساحة عمودية ممكنة
      crossAxisAlignment: CrossAxisAlignment.stretch, // تمديد الأزرار أفقيًا
      children: [
        // زر "بدء التشخيص"
        AppButton(
          text: localizations.startDiagnosis,
          // تعطيل الزر بصريًا إذا كان canDiagnose هو false
          onPressed: canDiagnose ? _runDiagnosis : () {},
          isLoading: _status == DiagnosisScreenStatus.loading, // عرض مؤشر التحميل بالداخل
          icon: Icons.biotech_outlined, // أيقونة ذات صلة
        ),

        // زر "مسح" / "تشخيص صورة أخرى" (يُعرض شرطيًا)
        // استخدام Visibility لعرض شرطي أنظف
        Visibility(
          visible: showClearButton,
          child: Padding(
            padding: const EdgeInsets.only(top: AppConstants.smallPadding),
            child: TextButton(
              onPressed: _clearState,
              child: Text(
                _status == DiagnosisScreenStatus.success
                    ? localizations.diagnoseAnotherImage
                    : localizations.clear,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppConstants.primaryColorDark,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
      ],
    );
  }
}