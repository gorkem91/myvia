import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_picker/image_picker.dart';

// Klasör yapına göre importları kontrol et
import 'home_controller.dart'; 
import '../../auth/presentation/auth_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  File? _selectedImage;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      // Yeni resim seçince eski analizi temizlemek istersen buraya bir reset metodu ekleyebilirsin
    }
  }

  @override
  Widget build(BuildContext context) {
    final aiState = ref.watch(homeControllerProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vision AI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Çıkış Yap',
            onPressed: () {
              // Sadece bunu çağırmak yeterli. 
              // AuthGate, çıkış yapıldığını anlayıp otomatik Login ekranına atacak.
              ref.read(authControllerProvider.notifier).signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Resim Alanı
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_selectedImage!, fit: BoxFit.contain),
                      )
                    : const Center(
                        child: Icon(Icons.add_photo_alternate_outlined, size: 80, color: Colors.grey),
                      ),
              ),
              const SizedBox(height: 24),
              
              // Butonlar
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: pickImage,
                      icon: const Icon(Icons.image),
                      label: const Text('Resim Seç'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: (_selectedImage != null && !aiState.isLoading)
                          ? () {
                              ref.read(homeControllerProvider.notifier).analyze(_selectedImage!);
                            }
                          : null,
                      icon: aiState.isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.auto_awesome),
                      label: Text(aiState.isLoading ? 'Analiz...' : 'Analiz Et'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Sonuç Alanı
              if (aiState.hasError)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade100),
                  ),
                  child: Text('Hata: ${aiState.error}', style: const TextStyle(color: Colors.red)),
                )
              else if (aiState.isLoading)
                const CircularProgressIndicator()
              else if (aiState.value != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.deepPurple.shade100),
                    boxShadow: [
                       BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                    ]
                  ),
                  child: MarkdownBody(data: aiState.value!),
                ),
            ],
          ),
        ),
      ),
    );
  }
}