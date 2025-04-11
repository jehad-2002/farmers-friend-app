import 'package:farmersfriendapp/core/database/database_helper.dart';
import 'package:farmersfriendapp/core/network/api_client.dart';

// --- DataSources ---
import 'package:farmersfriendapp/features/authentication/data/datasources/auth_local_datasource.dart';
import 'package:farmersfriendapp/features/authentication/domain/usecases/delete_user.dart';
import 'package:farmersfriendapp/features/authentication/domain/usecases/get_all_users.dart';
import 'package:farmersfriendapp/features/category/data/datasources/category_local_datasource.dart';
import 'package:farmersfriendapp/features/crop/data/datasources/crop_local_datasource.dart';
import 'package:farmersfriendapp/features/diagnosis/data/diagnosis/diagnosis_local_datasource.dart';
import 'package:farmersfriendapp/features/evaluation/data/datasources/evaluation_local_datasource.dart';
import 'package:farmersfriendapp/features/guideline/data/datasources/guideline_local_datasource.dart';
import 'package:farmersfriendapp/features/product/data/datasources/product_local_datasource.dart';
import 'package:farmersfriendapp/features/weather/data/datasources/weather_remote_datasource.dart';
// Corrected import path for Diagnosis DataSource

// --- Repositories ---
import 'package:farmersfriendapp/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:farmersfriendapp/features/authentication/domain/repositories/auth_repository.dart';
import 'package:farmersfriendapp/features/category/data/repositories/category_repository_impl.dart';
import 'package:farmersfriendapp/features/category/domain/repositories/category_repository.dart';
import 'package:farmersfriendapp/features/crop/data/repositories/crop_repository_impl.dart';
import 'package:farmersfriendapp/features/crop/domain/repositories/crop_repository.dart';
import 'package:farmersfriendapp/features/evaluation/data/repositories/evaluation_repository_impl.dart';
import 'package:farmersfriendapp/features/evaluation/domain/repositories/evaluation_repository.dart';
import 'package:farmersfriendapp/features/guideline/data/repositories/guideline_repository_impl.dart';
import 'package:farmersfriendapp/features/guideline/domain/repositories/guideline_repository.dart';
import 'package:farmersfriendapp/features/product/data/repositories/product_repository_impl.dart';
import 'package:farmersfriendapp/features/product/domain/repositories/product_repository.dart';
import 'package:farmersfriendapp/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:farmersfriendapp/features/weather/domain/repositories/weather_repository.dart';
// Import for Diagnosis Repository
import 'package:farmersfriendapp/features/diagnosis/data/repositories/diagnosis_repository_impl.dart';
import 'package:farmersfriendapp/features/diagnosis/domain/repositories/diagnosis_repository.dart';

// --- UseCases ---
import 'package:farmersfriendapp/features/authentication/domain/usecases/get_user.dart';
import 'package:farmersfriendapp/features/authentication/domain/usecases/login_user.dart';
import 'package:farmersfriendapp/features/authentication/domain/usecases/register_user.dart';
import 'package:farmersfriendapp/features/authentication/domain/usecases/update_user.dart';
import 'package:farmersfriendapp/features/category/domain/usecases/add_category.dart';
import 'package:farmersfriendapp/features/category/domain/usecases/delete_category.dart';
import 'package:farmersfriendapp/features/category/domain/usecases/get_all_categories.dart';
import 'package:farmersfriendapp/features/category/domain/usecases/update_category.dart';
import 'package:farmersfriendapp/features/crop/domain/usecases/add_crop.dart';
import 'package:farmersfriendapp/features/crop/domain/usecases/delete_crop.dart';
import 'package:farmersfriendapp/features/crop/domain/usecases/get_all_crops.dart';
import 'package:farmersfriendapp/features/crop/domain/usecases/get_crop_by_id.dart';
import 'package:farmersfriendapp/features/crop/domain/usecases/update_crop.dart';
import 'package:farmersfriendapp/features/evaluation/domain/usecases/add_evaluation.dart';
import 'package:farmersfriendapp/features/evaluation/domain/usecases/delete_evaluation.dart';
import 'package:farmersfriendapp/features/evaluation/domain/usecases/get_evaluations_for_product.dart';
import 'package:farmersfriendapp/features/evaluation/domain/usecases/update_evaluation.dart';
import 'package:farmersfriendapp/features/guideline/domain/usecases/add_guideline.dart';
import 'package:farmersfriendapp/features/guideline/domain/usecases/add_guideline_image.dart';
import 'package:farmersfriendapp/features/guideline/domain/usecases/delete_guideline.dart';
import 'package:farmersfriendapp/features/guideline/domain/usecases/delete_guideline_image.dart';
import 'package:farmersfriendapp/features/guideline/domain/usecases/get_guideline_images.dart';
import 'package:farmersfriendapp/features/guideline/domain/usecases/get_guidelines_for_crop.dart';
import 'package:farmersfriendapp/features/guideline/domain/usecases/get_guidelines_with_images.dart';
import 'package:farmersfriendapp/features/guideline/domain/usecases/get_guidelines_with_images_by_crop.dart';
import 'package:farmersfriendapp/features/guideline/domain/usecases/update_guideline.dart';
import 'package:farmersfriendapp/features/product/domain/usecases/add_product.dart';
import 'package:farmersfriendapp/features/product/domain/usecases/add_product_image.dart';
import 'package:farmersfriendapp/features/product/domain/usecases/delete_product.dart';
import 'package:farmersfriendapp/features/product/domain/usecases/delete_product_image.dart';
import 'package:farmersfriendapp/features/product/domain/usecases/get_all_products.dart';
import 'package:farmersfriendapp/features/product/domain/usecases/get_all_products_with_images.dart';
import 'package:farmersfriendapp/features/product/domain/usecases/get_product_images.dart';
import 'package:farmersfriendapp/features/product/domain/usecases/get_products_by_user.dart';
import 'package:farmersfriendapp/features/product/domain/usecases/get_products_with_images_by_user.dart';
import 'package:farmersfriendapp/features/product/domain/usecases/update_product.dart';
import 'package:farmersfriendapp/features/weather/domain/usecases/get_weather.dart';
// Import for Diagnosis UseCase
import 'package:farmersfriendapp/features/diagnosis/domain/usecases/diagnose_image.dart';

// Global instance of the Service Locator
// Consider using GetIt package for more advanced features like lazy singletons
final sl = ServiceLocator();

/// Service Locator class responsible for dependency injection.
/// Creates and provides instances of DataSources, Repositories, and UseCases.
class ServiceLocator {
  // --- Core Dependencies ---
  late final ApiClient apiClient;
  late final DatabaseHelper dbHelper;

  // --- DataSources ---
  late final AuthLocalDataSource authLocalDataSource;
  late final CategoryLocalDataSource categoryLocalDataSource;
  late final CropLocalDataSource cropLocalDataSource;
  late final ProductLocalDataSource productLocalDataSource;
  late final EvaluationLocalDataSource evaluationLocalDataSource;
  late final GuidelineLocalDataSource guidelineLocalDataSource;
  late final WeatherRemoteDataSource weatherRemoteDataSource;
  late final DiagnosisLocalDataSource diagnosisLocalDataSource; // Added

  // --- Repositories ---
  late final AuthRepository authRepository;
  late final CategoryRepository categoryRepository;
  late final CropRepository cropRepository;
  late final ProductRepository productRepository;
  late final EvaluationRepository evaluationRepository;
  late final GuidelineRepository guidelineRepository;
  late final WeatherRepository weatherRepository;
  late final DiagnosisRepository diagnosisRepository; // Added

  // --- UseCases ---
  // Authentication
  late final RegisterUser registerUser;
  late final LoginUser loginUser;
  late final GetUser getUser;
  late final UpdateUser updateUser;
  late final GetAllUsers getAllUsers;
  late final DeleteUser deleteUser;
  // Category
  late final GetAllCategories getAllCategories;
  late final AddCategory addCategory;
  late final UpdateCategory updateCategory;
  late final DeleteCategory deleteCategory;
  // Crop
  late final GetAllCrops getAllCrops;
  late final AddCrop addCrop;
  late final UpdateCrop updateCrop;
  late final DeleteCrop deleteCrop;
  late final GetCropById getCropById;
  // Product
  late final GetAllProducts getAllProducts;
  late final GetAllProductsWithImages getAllProductsWithImages;
  late final GetProductsByUser getProductsByUser;
  late final GetProductsWithImagesByUser getProductsWithImagesByUser;
  late final AddProduct addProduct;
  late final UpdateProduct updateProduct;
  late final DeleteProduct deleteProduct;
  late final GetProductImages getProductImages;
  late final AddProductImage addProductImage;
  late final DeleteProductImage deleteProductImage;
  // Evaluation
  late final GetEvaluationsForProduct getEvaluationsForProduct;
  late final AddEvaluation addEvaluation;
  late final UpdateEvaluation updateEvaluation;
  late final DeleteEvaluation deleteEvaluation;
  // Guideline
  late final GetGuidelinesForCrop getGuidelinesForCrop;
  late final GetGuidelinesWithImages getGuidelinesWithImages;
  late final GetGuidelinesWithImagesByCrop getGuidelinesWithImagesByCrop;
  late final AddGuideline addGuideline;
  late final UpdateGuideline updateGuideline;
  late final DeleteGuideline deleteGuideline;
  late final GetGuidelineImages getGuidelineImages;
  late final AddGuidelineImage addGuidelineImage;
  late final DeleteGuidelineImage deleteGuidelineImage;
  // Weather
  late final GetWeather getWeather;
  // Diagnosis
  late final DiagnoseImage diagnoseImage; // Added

  /// Constructor where all dependencies are initialized and registered.
  /// The order of initialization matters: DataSources -> Repositories -> UseCases.
  ServiceLocator() {
    // --- Initialize Core Dependencies ---
    // These are typically singletons used by multiple data sources
    apiClient = ApiClient();
    dbHelper = DatabaseHelper();

    // --- Initialize DataSources ---
    // DataSources depend on core dependencies (ApiClient, DatabaseHelper)
    authLocalDataSource = AuthLocalDataSourceImpl(dbHelper: dbHelper);
    categoryLocalDataSource = CategoryLocalDataSourceImpl(dbHelper: dbHelper);
    cropLocalDataSource = CropLocalDataSourceImpl(dbHelper: dbHelper);
    productLocalDataSource = ProductLocalDataSourceImpl(dbHelper: dbHelper);
    evaluationLocalDataSource =
        EvaluationLocalDataSourceImpl(dbHelper: dbHelper);
    guidelineLocalDataSource = GuidelineLocalDataSourceImpl(dbHelper: dbHelper);
    weatherRemoteDataSource = WeatherRemoteDataSourceImpl(apiClient: apiClient);
    // Initialize the new Diagnosis DataSource
    diagnosisLocalDataSource =
        DiagnosisLocalDataSourceImpl(); // Doesn't need dbHelper or apiClient directly

    // --- Initialize Repositories ---
    // Repositories depend on their corresponding DataSources
    authRepository = AuthRepositoryImpl(localDataSource: authLocalDataSource);
    categoryRepository =
        CategoryRepositoryImpl(localDataSource: categoryLocalDataSource);
    cropRepository = CropRepositoryImpl(localDataSource: cropLocalDataSource);
    productRepository =
        ProductRepositoryImpl(localDataSource: productLocalDataSource);
    evaluationRepository =
        EvaluationRepositoryImpl(localDataSource: evaluationLocalDataSource);
    guidelineRepository =
        GuidelineRepositoryImpl(localDataSource: guidelineLocalDataSource);
    weatherRepository =
        WeatherRepositoryImpl(remoteDataSource: weatherRemoteDataSource);
    // Initialize the new Diagnosis Repository, passing its DataSource
    diagnosisRepository =
        DiagnosisRepositoryImpl(localDataSource: diagnosisLocalDataSource);

    // --- Initialize UseCases ---
    // UseCases depend on their corresponding Repositories
    _registerUseCases(); // Call the private method to keep the constructor cleaner
  }

  /// Private helper method to register all UseCases.
  void _registerUseCases() {
    // Authentication
    registerUser = RegisterUser(authRepository);
    loginUser = LoginUser(authRepository);
    getUser = GetUser(authRepository);
    updateUser = UpdateUser(authRepository);
    deleteUser=DeleteUser(authRepository);
    getAllUsers=GetAllUsers(authRepository);
    // Category
    getAllCategories = GetAllCategories(categoryRepository);
    addCategory = AddCategory(categoryRepository);
    updateCategory = UpdateCategory(categoryRepository);
    deleteCategory = DeleteCategory(categoryRepository);
    // Crop
    getAllCrops = GetAllCrops(cropRepository);
    addCrop = AddCrop(cropRepository);
    updateCrop = UpdateCrop(cropRepository);
    deleteCrop = DeleteCrop(cropRepository);
    getCropById = GetCropById(cropRepository);
    // Product
    getAllProducts = GetAllProducts(productRepository);
    getAllProductsWithImages = GetAllProductsWithImages(productRepository);
    getProductsByUser = GetProductsByUser(productRepository);
    getProductsWithImagesByUser =
        GetProductsWithImagesByUser(productRepository);
    addProduct = AddProduct(productRepository);
    updateProduct = UpdateProduct(productRepository);
    deleteProduct = DeleteProduct(productRepository);
    getProductImages = GetProductImages(productRepository);
    addProductImage = AddProductImage(productRepository);
    deleteProductImage = DeleteProductImage(productRepository);
    // Evaluation
    getEvaluationsForProduct = GetEvaluationsForProduct(evaluationRepository);
    addEvaluation = AddEvaluation(evaluationRepository);
    updateEvaluation = UpdateEvaluation(evaluationRepository);
    deleteEvaluation = DeleteEvaluation(evaluationRepository);
    // Guideline
    getGuidelinesForCrop = GetGuidelinesForCrop(guidelineRepository);
    getGuidelinesWithImages = GetGuidelinesWithImages(guidelineRepository);
    getGuidelinesWithImagesByCrop =
        GetGuidelinesWithImagesByCrop(guidelineRepository);
    addGuideline = AddGuideline(guidelineRepository);
    updateGuideline = UpdateGuideline(guidelineRepository);
    deleteGuideline = DeleteGuideline(guidelineRepository);
    getGuidelineImages = GetGuidelineImages(guidelineRepository);
    addGuidelineImage = AddGuidelineImage(guidelineRepository);
    deleteGuidelineImage = DeleteGuidelineImage(guidelineRepository);
    // Weather
    getWeather = GetWeather(weatherRepository);
    // Diagnosis - Register the new UseCase, passing its Repository
    diagnoseImage = DiagnoseImage(diagnosisRepository);
  }

  /// Static method to perform any necessary asynchronous initialization.
  /// Typically called once in `main.dart` before `runApp`.
  static Future<void> initializeDependencies() async {
    print("Initializing core dependencies...");
    // Ensure the database is initialized before the app runs
    await sl.dbHelper.database;
    print("Database initialized.");

    // Optional: Eagerly load the TFLite model if desired.
    // However, lazy loading within the DataSource is often preferred.
    // try {
    //   await sl.diagnosisLocalDataSource.loadModel();
    //   print("Diagnosis model pre-loaded.");
    // } catch (e) {
    //   print("WARNING: Failed to pre-load diagnosis model during initialization: $e");
    //   // The app can still run, loading will be attempted on first use.
    // }

    print("Service Locator dependencies ready.");
  }
}
