
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../data/gemini_repository.dart';


class HomeController extends StateNotifier<AsyncValue<String?>> {
  final GeminiRepository repository;
  HomeController(this.repository) : super(const AsyncValue.data(null));

  Future<void> analyze(File image) async {
    state = const AsyncValue.loading();
    try {
      final result = await repository.analyzeImage(image);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final homeControllerProvider = StateNotifierProvider<HomeController, AsyncValue<String?>>(
  (ref) => HomeController(ref.read(geminiRepositoryProvider)),
);
