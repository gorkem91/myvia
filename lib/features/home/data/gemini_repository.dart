import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../core/constants/app_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GeminiRepository {
  Future<String?> analyzeImage(File image) async {
    final model = GenerativeModel(
      model: AppConstants.modelName,
      apiKey: AppConstants.apiKey,
    );
    final content = [
      Content.multi([
        TextPart('Bu resmi analiz et. Türkçe detaylı açıkla. cümle başında elbette ve benzeri kelimeler kullanma direkt konuya gir'),
        DataPart('image/jpeg', await image.readAsBytes()),
      ])
    ];
    final response = await model.generateContent(content);
    return response.text;
  }
}

final geminiRepositoryProvider = Provider((ref) => GeminiRepository());
