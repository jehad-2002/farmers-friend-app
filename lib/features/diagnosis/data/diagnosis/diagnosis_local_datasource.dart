import 'dart:io';
import 'dart:typed_data';
import 'package:farmersfriendapp/features/product/data/diagnosis_constants.dart';
import 'package:image/image.dart' as img_lib;
import 'package:tflite_flutter/tflite_flutter.dart';

abstract class DiagnosisLocalDataSource {
  Future<void> loadModel();
  Future<String> runDiagnosis(File imageFile);
}

class DiagnosisLocalDataSourceImpl implements DiagnosisLocalDataSource {
  Interpreter? _interpreter;
  bool _isModelLoaded = false;

  // Lazy load the model on first diagnosis request if not already loaded
  Future<void> _ensureModelLoaded() async {
    if (!_isModelLoaded && _interpreter == null) {
      await loadModel();
    }
    if (_interpreter == null) {
      throw Exception('Diagnosis model failed to load and is unavailable.');
    }
  }

  @override
  Future<void> loadModel() async {
    // Prevent concurrent loading attempts
    if (_interpreter != null) return;

    try {
      _interpreter = await Interpreter.fromAsset(DiagnosisConstants.modelPath);
      // Optional: Allocate tensors at loading time if needed by the model
      // _interpreter?.allocateTensors();
      _isModelLoaded = true;
      print('Diagnosis model loaded successfully.');
    } catch (e) {
      _isModelLoaded = false; // Ensure flag is false on error
      print('Error loading diagnosis model: $e');
      // Re-throw a more specific exception if needed, or handle it later
      throw Exception('Failed to load model: $e');
    }
  }

  // --- Image Preprocessing ---
  // IMPORTANT: This function MUST match the preprocessing used during model training.
  // This example assumes Float32 input, normalized to [0, 1], in RGB order.
  // Adjust resolution, normalization, data type (Float32List/Uint8List), and color order (RGB/BGR)
  // based on your specific model's requirements.
  Float32List _preprocessImageFloat32(img_lib.Image image) {
    final resizedImage = img_lib.copyResize(
      image,
      width: DiagnosisConstants.imgWidth,
      height: DiagnosisConstants.imgHeight,
      interpolation: img_lib.Interpolation.average, // Or bilinear, cubic
    );

    // Create a Float32List for the input tensor [1, H, W, C]
    final imageBytes = Float32List(
        1 * DiagnosisConstants.imgHeight * DiagnosisConstants.imgWidth * 3);
    int pixelIndex = 0;

    for (int y = 0; y < DiagnosisConstants.imgHeight; y++) {
      for (int x = 0; x < DiagnosisConstants.imgWidth; x++) {
        final pixel = resizedImage.getPixel(x, y);
        // Normalize pixel values to [0, 1] and set in RGB order
        imageBytes[pixelIndex++] = pixel.r / 255.0;
        imageBytes[pixelIndex++] = pixel.g / 255.0;
        imageBytes[pixelIndex++] = pixel.b / 255.0;
      }
    }
    return imageBytes;
  }

  @override
  Future<String> runDiagnosis(File imageFile) async {
    await _ensureModelLoaded(); // Ensure the model is loaded

    try {
      // 1. Read and Decode Image
      final imageBytes = await imageFile.readAsBytes();
      final img_lib.Image? decodedImage = img_lib.decodeImage(imageBytes);
      if (decodedImage == null) {
        throw Exception('Failed to decode image file.');
      }

      // 2. Preprocess Image
      // Use the correct preprocessing function based on your model
      final inputBytes = _preprocessImageFloat32(decodedImage);
      // Reshape to match model input tensor shape [1, height, width, channels]
      final input = inputBytes.reshape(
          [1, DiagnosisConstants.imgHeight, DiagnosisConstants.imgWidth, 3]);

      // 3. Prepare Output Tensor
      // Shape should be [1, number_of_classes]
      final outputShape = [1, DiagnosisConstants.classMapping.length];
      // Initialize output tensor (e.g., with zeros)
      final output = List.filled(outputShape[0] * outputShape[1], 0.0)
          .reshape(outputShape);

      // 4. Run Inference
      _interpreter!.run(input, output);

      // 5. Postprocess Output
      // Output[0] contains the list of probabilities for each class
      final predictions = output[0] as List<double>;
      int predictedClassIndex = 0;
      double maxConfidence = 0.0;

      for (int i = 0; i < predictions.length; i++) {
        if (predictions[i] > maxConfidence) {
          maxConfidence = predictions[i];
          predictedClassIndex = i;
        }
      }

      // 6. Get Class Name
      final predictedClassName =
          DiagnosisConstants.classMapping[predictedClassIndex];
      if (predictedClassName == null) {
        throw Exception(
            'Predicted class index $predictedClassIndex is out of bounds for the defined class mapping.');
      }

      // Optional: Log confidence
      print(
          "Diagnosis Result - Raw: $predictedClassName, Confidence: ${maxConfidence.toStringAsFixed(3)}");

      // Return the formatted name for display
      return DiagnosisConstants.formatClassName(predictedClassName);
    } on Exception catch (e) {
      print("Error during diagnosis run: $e");
      // Re-throw to be caught by the repository
      rethrow;
    } catch (e) {
      print("Unexpected error during diagnosis run: $e");
      throw Exception('An unexpected error occurred during diagnosis: $e');
    }
  }
}
